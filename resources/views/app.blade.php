<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="icon" type="image/png" href="{{ Vite::asset('public/images/icodexies-logo.png') }}">
        @routes
        
        @vite(['resources/js/app.js', 'resources/css/app.css'])
        
        <x-inertia::head />
    </head>
    <body class="antialiased">
        <x-inertia::app />
    </body>
</html>