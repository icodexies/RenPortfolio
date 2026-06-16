<script setup>
import { ref, watch, nextTick } from 'vue'
import { animate } from 'motion'

const isMobileMenuOpen = ref(false)
const mobileMenuRef = ref(null)

const toggleMobileMenu = () => {
  isMobileMenuOpen.value = !isMobileMenuOpen.value
}

watch(isMobileMenuOpen, async (isOpen) => {
  if (isOpen) {
    await nextTick()
    animate(
      mobileMenuRef.value,
      { height: [0, 'auto'], opacity: [0, 1] },
      { duration: 0.3, easing: 'ease-out' }
    )
  } else {
    animate(
      mobileMenuRef.value,
      { height: 0, opacity: 0 },
      { duration: 0.25, easing: 'ease-in-out' }
    )
  }
})

const isActive = (routeName) => {
  return route().current(routeName)
}
</script>

<template>
  <div class="flex flex-col min-h-screen bg-[#030712] text-slate-200 font-sans antialiased selection:bg-orange-500/30">

    <header class="sticky top-0 z-50 bg-[#030712]/50 backdrop-blur-xl border-b border-white/[0.06]">
      <nav class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-20">

          <div class="flex-shrink-0 flex items-center">
            <img
              :src="'/images/icodexies-logo.png'"
              alt="ICODEXIES Logo"
              class="w-15 h-15 object-contain"
            />
            <span class="font-extrabold text-xl tracking-wider text-white uppercase font-mono">
              ICODEX<span class="text-transparent bg-clip-text bg-gradient-to-r from-orange-500 via-rose-500 to-indigo-400">IES</span>
            </span>
          </div>

          <!-- Desktop navigation with refined active state -->
          <div class="hidden md:flex items-center space-x-1">
            <a :href="route('home')"      :class="['nav-link', { 'nav-link--active': isActive('home') }]">Home</a>
            <a :href="route('project')"   :class="['nav-link', { 'nav-link--active': isActive('project') }]">Projects</a>
            <a :href="route('techStack')" :class="['nav-link', { 'nav-link--active': isActive('techStack') }]">Tech Stack</a>
            <a :href="route('resume')"    :class="['nav-link', { 'nav-link--active': isActive('resume') }]">Resume</a>
          </div>

          <div class="hidden md:flex items-center gap-4">
            <a
              :href="route('resume')"
              class="relative inline-flex items-center justify-center p-0.5 overflow-hidden text-sm font-bold text-white rounded-lg group bg-gradient-to-br from-orange-500 via-rose-500 to-indigo-600 shadow-lg shadow-orange-500/10"
            >
              <span class="relative px-5 py-2 transition-all ease-in duration-75 bg-[#030712]/90 rounded-md group-hover:bg-opacity-0">
                Let's Build
              </span>
            </a>
          </div>

          <!-- Mobile menu button -->
          <div class="flex md:hidden">
            <button
              @click="toggleMobileMenu"
              class="inline-flex items-center justify-center p-2 rounded-md text-slate-400 hover:text-white hover:bg-white/[0.06] focus:outline-none transition-colors"
              aria-label="Toggle Navigation Menu"
            >
              <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path v-if="!isMobileMenuOpen" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
                <path v-else stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
        </div>
      </nav>

      <!-- Mobile menu -->
      <div
        v-show="isMobileMenuOpen"
        ref="mobileMenuRef"
        class="md:hidden border-t border-white/[0.06] bg-[#030712]/70 backdrop-blur-xl overflow-hidden origin-top"
        style="height: 0px; opacity: 0;"
      >
        <div class="px-3 pt-3 pb-4 space-y-1">
          <a @click="isMobileMenuOpen = false" :href="route('home')"      class="block px-4 py-2.5 rounded-md text-base font-medium text-slate-300 hover:bg-white/[0.06] hover:text-white transition-colors">Home</a>
          <a @click="isMobileMenuOpen = false" :href="route('project')"   class="block px-4 py-2.5 rounded-md text-base font-medium text-slate-300 hover:bg-white/[0.06] hover:text-white transition-colors">Projects</a>
          <a @click="isMobileMenuOpen = false" :href="route('techStack')" class="block px-4 py-2.5 rounded-md text-base font-medium text-slate-300 hover:bg-white/[0.06] hover:text-white transition-colors">Tech Stack</a>
          <div class="pt-4 pb-2 border-t border-white/[0.06] mt-2 px-4">
            <a
              @click="isMobileMenuOpen = false"
              :href="route('resume')"
              class="block w-full text-center bg-gradient-to-r from-orange-500 via-rose-500 to-indigo-600 text-white font-bold py-2.5 rounded-md shadow-md shadow-rose-500/10"
            >
              Let's Connect
            </a>
          </div>
        </div>
      </div>
    </header>

    <main class="w-full max-w-full flex-grow flex flex-col min-h-[calc(100vh-5rem)]">
      <div class="w-full flex-grow">
        <slot />
      </div>
    </main>

    <footer class="relative overflow-hidden border-t border-white/[0.06] bg-[#030712]/60 backdrop-blur-xl mt-auto">
      <!-- footer content unchanged -->
      <div class="absolute -top-24 left-1/4 w-96 h-96 bg-indigo-600/8 rounded-full blur-3xl pointer-events-none"></div>
      <div class="absolute -bottom-24 right-1/4 w-96 h-96 bg-orange-600/5 rounded-full blur-3xl pointer-events-none"></div>

      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 md:py-16 relative z-10">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-10">

          <div class="space-y-4">
            <div class="flex items-center gap-3">
              <img
                :src="'/images/icodexies-logo.png'"
                alt="ICODEXIES Logo Footer"
                class="w-15 h-15 object-contain"
              />
              <span class="font-bold text-white tracking-wider font-mono uppercase">ICODEXIES</span>
            </div>
            <p class="text-sm text-slate-500 max-w-xs leading-relaxed">
              Full-Stack developer workspace crafting web applications with high-fidelity design systems and hardware-accelerated user interactions.
            </p>
          </div>

          <div>
            <h3 class="text-xs font-bold text-slate-600 uppercase tracking-widest mb-4">Portfolio Navigation</h3>
            <ul class="space-y-2.5 text-sm">
              <li><a :href="route('project')"    class="text-slate-500 hover:text-orange-400 transition-colors">Projects</a></li>
              <li><a :href="route('techStack')" class="text-slate-500 hover:text-orange-400 transition-colors">Tech Stack</a></li>
              <li><a :href="route('resume')"    class="text-slate-500 hover:text-orange-400 transition-colors">Resume & Contacts</a></li>
            </ul>
          </div>

          <div>
            <h3 class="text-xs font-bold text-slate-600 uppercase tracking-widest mb-4">Terminals</h3>
            <ul class="space-y-2.5 text-sm">
              <li><a href="https://github.com/icodexies"   target="_blank" class="text-slate-500 hover:text-indigo-400 transition-colors">GitHub Profile</a></li>
              <li><a href="https://www.linkedin.com/in/renuell-niquit-30264a39a/" target="_blank" class="text-slate-500 hover:text-indigo-400 transition-colors">LinkedIn Connect</a></li>
              <li><a href="mailto:contact@icodexies.com"        class="text-slate-500 hover:text-indigo-400 transition-colors">Email Network</a></li>
            </ul>
          </div>
        </div>

        <div class="border-t border-white/[0.05] mt-12 pt-8 flex flex-col sm:flex-row items-center justify-between gap-4">
          <p class="text-xs text-slate-600 font-mono">
            &copy; 2026 ICODEXIES. Built with Laravel, Vue, & Tailwind CSS.
          </p>
          <div class="flex gap-4 text-xs font-semibold text-slate-500">
            <span class="inline-flex items-center gap-1.5">
              <span class="h-2 w-2 rounded-full bg-emerald-500 animate-pulse"></span>
              Open for Projects
            </span>
          </div>
        </div>
      </div>
    </footer>
  </div>
</template>

<style scoped>
/* Base nav link */
.nav-link {
  position: relative;
  padding: 0.5rem 1rem;
  border-radius: 0.75rem; /* slightly more rounded */
  font-size: 0.875rem;
  font-weight: 600;
  color: #94a3b8;
  transition: all 0.25s ease;
  text-decoration: none;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.nav-link:hover {
  color: #fff;
  background-color: rgba(255, 255, 255, 0.05);
}

/* Active link – special badge style */
.nav-link--active {
  color: #fff;
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.06);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);

}
.nav-link:not(.nav-link--active)::after {
  content: '';
  position: absolute;
  bottom: 6px;
  left: 1rem;
  right: 1rem;
  height: 2px;
  background: linear-gradient(to right, #f97316, #e11d48, #6366f1);
  transform: scaleX(0);
  transform-origin: left;
  transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.nav-link:not(.nav-link--active):hover::after {
  transform: scaleX(1);
}
</style>