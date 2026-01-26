'use client'

import { useState, useEffect } from 'react'
import Link from 'next/link'

const STORAGE_KEY = 'cookie-banner-dismissed'

export function CookieBanner() {
  const [visible, setVisible] = useState(false)

  useEffect(() => {
    // Check on client side only (localStorage not available during SSR)
    if (typeof window !== 'undefined' && !localStorage.getItem(STORAGE_KEY)) {
      setVisible(true)
    }
  }, [])

  const handleDismiss = () => {
    localStorage.setItem(STORAGE_KEY, 'true')
    setVisible(false)
  }

  if (!visible) return null

  return (
    <div
      className="fixed bottom-0 left-0 right-0 z-50 bg-[var(--navy-dark)] text-white px-6 py-3 shadow-[0_-2px_10px_rgba(0,0,0,0.1)] animate-fade-in"
    >
      <div className="max-w-7xl mx-auto flex flex-wrap items-center justify-between gap-4">
        <p className="text-sm">
          Deze website gebruikt alleen noodzakelijke cookies voor het functioneren van de site.{' '}
          Meer informatie in ons{' '}
          <Link href="/privacybeleid" className="underline hover:no-underline">
            Privacybeleid
          </Link>.
        </p>
        <button
          onClick={handleDismiss}
          className="bg-[var(--pink)] hover:opacity-90 text-white px-4 py-2 rounded text-sm font-medium transition-opacity min-w-[44px] min-h-[44px]"
        >
          OK
        </button>
      </div>
    </div>
  )
}
