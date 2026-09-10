<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/health', fn () => response()->json(['status' => 'ok']));

Route::get('/ping-queue', function () {
    dispatch(function () {
        \Log::info('ping-queue job executed at '.now());
    });
    return 'queued';
});
