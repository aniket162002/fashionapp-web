<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('orders', function (Blueprint $table) {
            // Update the tracking_code field to support URLs and add comment
            $table->text('tracking_code')->nullable()->change()->comment('Tracking URL for the order shipment');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('orders', function (Blueprint $table) {
            // Revert back to varchar(255)
            $table->string('tracking_code', 255)->nullable()->change();
        });
    }
};