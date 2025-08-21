@extends('backend.layouts.app')

@section('title', 'WhatsApp OTP Configuration')

@section('content')
<div class="row">
    <div class="col-lg-12">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0 h6">WhatsApp API Configuration</h5>
            </div>
            <div class="card-body">
                <form action="{{ route('whatsapp_otp.configuration.update') }}" method="POST">
                    @csrf
                    <div class="form-group row">
                        <label class="col-md-3 col-form-label">API URL</label>
                        <div class="col-md-9">
                            <input type="text" class="form-control" name="api_url" value="{{ $settings->api_url ?? '' }}" placeholder="https://graph.facebook.com/v17.0">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-md-3 col-form-label">Access Token</label>
                        <div class="col-md-9">
                            <input type="text" class="form-control" name="access_token" value="{{ $settings->access_token ?? '' }}" placeholder="Enter your WhatsApp Business API access token">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-md-3 col-form-label">Phone Number ID</label>
                        <div class="col-md-9">
                            <input type="text" class="form-control" name="phone_number_id" value="{{ $settings->phone_number_id ?? '' }}" placeholder="Enter your WhatsApp Business phone number ID">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-md-3 col-form-label">Webhook Verify Token</label>
                        <div class="col-md-9">
                            <input type="text" class="form-control" name="webhook_verify_token" value="{{ $settings->webhook_verify_token ?? '' }}" placeholder="Enter webhook verify token">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-md-3 col-form-label">Webhook URL</label>
                        <div class="col-md-9">
                            <input type="text" class="form-control" value="{{ url('/whatsapp-otp/webhook') }}" readonly>
                            <small class="text-muted">Copy this URL and set it in your WhatsApp Business API settings</small>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-md-3 col-form-label">Status</label>
                        <div class="col-md-9">
                            <label class="aiz-switch aiz-switch-success mb-0">
                                <input type="checkbox" name="status" @if($settings->status ?? 0) checked @endif>
                                <span class="slider round"></span>
                            </label>
                        </div>
                    </div>
                    <div class="form-group mb-0 text-right">
                        <button type="submit" class="btn btn-primary">Save</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
@endsection 