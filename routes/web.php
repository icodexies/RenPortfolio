<?php

use Illuminate\Support\Facades\Route;
use Inertia\Inertia;
Route::inertia('/', 'Home')->name('home');
Route::inertia('/Projects', 'Project')->name('project');
Route::inertia('/TechStack', 'TechStack')->name('techStack');
Route::inertia('/Resume', 'Resume')->name('resume');