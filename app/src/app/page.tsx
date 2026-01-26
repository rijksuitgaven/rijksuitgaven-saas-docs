import Link from 'next/link'

const modules = [
  { name: 'instrumenten', display: 'Financiële Instrumenten', description: 'Subsidies, regelingen en bijdragen' },
  { name: 'apparaat', display: 'Apparaatsuitgaven', description: 'Operationele kosten per kostensoort' },
  { name: 'inkoop', display: 'Inkoopuitgaven', description: 'Inkoop bij leveranciers' },
  { name: 'provincie', display: 'Provinciale Subsidies', description: 'Subsidies van provincies' },
  { name: 'gemeente', display: 'Gemeentelijke Subsidies', description: 'Subsidies van gemeenten' },
  { name: 'publiek', display: 'Publiek', description: 'RVO, COA, NWO uitbetalingen' },
]

export default function Home() {
  return (
    <div className="min-h-screen bg-white">
      {/* Header */}
      <header className="bg-[var(--navy-dark)] text-white px-6 py-6">
        <div className="max-w-7xl mx-auto">
          <h1 className="text-2xl font-semibold">Rijksuitgaven.nl</h1>
          <p className="text-[var(--blue-light)] mt-1">Snel inzicht voor krachtige analyses</p>
        </div>
      </header>

      {/* Main content */}
      <main className="max-w-7xl mx-auto px-6 py-12">
        <div className="mb-8">
          <h2 className="text-xl font-semibold text-[var(--navy-dark)]">Modules</h2>
          <p className="text-[var(--muted-foreground)] mt-1">
            Kies een module om de uitgavendata te bekijken
          </p>
        </div>

        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
          {modules.map((module) => (
            <Link
              key={module.name}
              href={`/${module.name}`}
              className="block p-6 border border-[var(--border)] rounded-lg hover:border-[var(--navy-medium)] hover:shadow-md transition-all"
            >
              <h3 className="text-lg font-semibold text-[var(--navy-dark)]">
                {module.display}
              </h3>
              <p className="text-sm text-[var(--muted-foreground)] mt-1">
                {module.description}
              </p>
            </Link>
          ))}
        </div>

        {/* Development status */}
        <div className="mt-12 p-6 bg-[var(--gray-light)] rounded-lg">
          <h3 className="font-semibold text-[var(--navy-dark)]">Week 3 - Core UI Components</h3>
          <ul className="mt-3 space-y-2 text-sm text-[var(--muted-foreground)]">
            <li className="flex items-center gap-2">
              <span className="w-2 h-2 rounded-full bg-[var(--warning)]" />
              Task 1: DataTable component - In Progress
            </li>
            <li className="flex items-center gap-2">
              <span className="w-2 h-2 rounded-full bg-[var(--gray-light)] border border-[var(--border)]" />
              Task 2: Expandable rows with grouping - Pending
            </li>
            <li className="flex items-center gap-2">
              <span className="w-2 h-2 rounded-full bg-[var(--gray-light)] border border-[var(--border)]" />
              Task 3: Filter panel with real-time filtering - Pending
            </li>
          </ul>
        </div>
      </main>
    </div>
  )
}
