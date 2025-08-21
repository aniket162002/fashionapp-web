<?php

namespace App\Http\Controllers\Api\V2;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class GooglePlacesController extends Controller
{
    public function getPlaceDetails(Request $request)
    {
        try {
            $placeId = $request->query('place_id');
            $address = $request->query('address');
            $apiKey = env('MAP_API_KEY');

            if (!$apiKey) {
                return response()->json([
                    'success' => false,
                    'message' => 'Google Places API key not configured'
                ], 500);
            }

            $resolvedPlaceId = $placeId;

            // If no place_id provided, try to resolve using address
            if (empty($resolvedPlaceId) && !empty($address)) {
                $findResponse = Http::get('https://maps.googleapis.com/maps/api/place/findplacefromtext/json', [
                    'input' => $address,
                    'inputtype' => 'textquery',
                    'fields' => 'place_id',
                    'key' => $apiKey,
                ]);

                if ($findResponse->successful()) {
                    $findData = $findResponse->json();
                    $candidates = $findData['candidates'] ?? [];
                    if (!empty($candidates)) {
                        $resolvedPlaceId = $candidates[0]['place_id'];
                    }
                }
            }

            if (empty($resolvedPlaceId)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Place ID could not be resolved'
                ], 400);
            }

            // Get place details
            $detailsResponse = Http::get('https://maps.googleapis.com/maps/api/place/details/json', [
                'place_id' => $resolvedPlaceId,
                'fields' => 'rating,reviews,user_ratings_total,url',
                'key' => $apiKey,
                'reviews_sort' => 'newest',
                'language' => 'en',
            ]);

            if (!$detailsResponse->successful()) {
                Log::error('Google Places API HTTP error', [
                    'status' => $detailsResponse->status(),
                    'body' => $detailsResponse->body()
                ]);
                return response()->json([
                    'success' => false,
                    'message' => 'Failed to fetch place details'
                ], 500);
            }

            $data = $detailsResponse->json();

            if ($data['status'] !== 'OK') {
                Log::error('Google Places API status error', [
                    'status' => $data['status'],
                    'error_message' => $data['error_message'] ?? 'No error message'
                ]);
                return response()->json([
                    'success' => false,
                    'message' => 'Google Places API error: ' . ($data['error_message'] ?? $data['status'])
                ], 400);
            }

            $result = $data['result'];
            $reviews = collect($result['reviews'] ?? [])->map(function ($review) {
                return [
                    'author_name' => $review['author_name'] ?? 'Anonymous',
                    'rating' => (float) ($review['rating'] ?? 0),
                    'text' => $review['text'] ?? '',
                    'time' => $review['time'] ?? 0,
                    'profile_photo_url' => $review['profile_photo_url'] ?? null,
                ];
            });

            return response()->json([
                'success' => true,
                'data' => [
                    'rating' => (float) ($result['rating'] ?? 0),
                    'user_ratings_total' => $result['user_ratings_total'] ?? 0,
                    'url' => $result['url'] ?? '',
                    'reviews' => $reviews,
                ]
            ]);

        } catch (\Exception $e) {
            Log::error('Google Places Controller error', [
                'message' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Internal server error'
            ], 500);
        }
    }
}