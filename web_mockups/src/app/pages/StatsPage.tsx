import { Header } from '@/app/components/organisms/Header';
import { StatCard } from '@/app/components/molecules/StatCard';
import { Icon } from '@/app/components/atoms/Icon';

export const StatsPage = () => {
  return (
    <main className="w-full h-full max-w-[430px] relative z-10 flex flex-col bg-bg-deep overflow-hidden">
      <header className="flex items-center justify-between px-6 pt-14 pb-4 bg-gradient-to-b from-bg-deep to-transparent z-20">
        <h1 className="font-title text-4xl text-white tracking-widest drop-shadow-md">
          MY PROGRESS
        </h1>
        <button className="relative p-2 rounded-full hover:bg-white/10 transition-colors group">
          <Icon name="notifications" className="text-white" />
          <span className="absolute top-2 right-2 w-2 h-2 bg-forge-fire rounded-full ring-2 ring-bg-deep" />
        </button>
      </header>

      <div className="flex-1 overflow-y-auto scrollbar-hide pb-24 px-6 space-y-6">
        {/* Progress Circle */}
        <section className="flex flex-col items-center justify-center py-4">
          <div className="relative w-48 h-48 flex items-center justify-center">
            <div className="absolute inset-0 rounded-full border border-white/5 shadow-[0_0_20px_rgba(255,69,0,0.2)] opacity-20" />
            <svg className="w-full h-full transform -rotate-90 drop-shadow-[0_0_15px_rgba(255,69,0,0.5)]">
              <circle
                cx="96"
                cy="96"
                r="88"
                fill="transparent"
                stroke="#1E1E1E"
                strokeWidth="8"
              />
              <circle
                cx="96"
                cy="96"
                r="88"
                fill="transparent"
                stroke="#FF4500"
                strokeWidth="8"
                strokeDasharray="552"
                strokeDashoffset="138"
                strokeLinecap="round"
              />
            </svg>
            <div className="absolute flex flex-col items-center">
              <span className="text-xs text-text-muted uppercase tracking-widest mb-1">
                Power Level
              </span>
              <span className="font-title text-6xl text-white leading-none">42</span>
              <span className="text-[10px] text-forge-fire font-bold uppercase tracking-wider mt-1">
                +12% This Week
              </span>
            </div>
          </div>
        </section>

        {/* Stats Grid */}
        <div className="grid grid-cols-2 gap-4">
          <StatCard
            icon="local_fire_department"
            value="14 Days"
            label="Current Streak"
            iconColor="text-forge-fire"
          />
          <StatCard
            icon="bolt"
            value="2.4k"
            label="Total XP"
            iconColor="text-electric-blue"
          />
        </div>

        {/* Activity Log */}
        <section className="bg-surface-dark/40 backdrop-blur-md border border-white/5 rounded-3xl p-5 shadow-lg">
          <div className="flex justify-between items-end mb-4">
            <h2 className="text-sm font-bold text-white uppercase tracking-wider">
              Activity Log
            </h2>
            <span className="text-[10px] text-text-muted">Last 3 Months</span>
          </div>
          <div className="flex gap-1 overflow-x-auto scrollbar-hide">
            {Array.from({ length: 12 }).map((_, weekIdx) => (
              <div key={weekIdx} className="flex flex-col gap-1">
                {Array.from({ length: 7 }).map((_, dayIdx) => {
                  const intensity = Math.random();
                  const opacity = intensity > 0.7 ? 1 : intensity > 0.4 ? 0.6 : intensity > 0.2 ? 0.3 : 0.05;
                  return (
                    <div
                      key={dayIdx}
                      className="w-3 h-3 rounded-sm bg-forge-fire"
                      style={{ opacity }}
                    />
                  );
                })}
              </div>
            ))}
          </div>
          <div className="flex items-center justify-end gap-2 mt-3 text-[9px] text-text-muted">
            <span>Less</span>
            <div className="w-2 h-2 rounded-sm bg-white/5" />
            <div className="w-2 h-2 rounded-sm bg-forge-fire/30" />
            <div className="w-2 h-2 rounded-sm bg-forge-fire/60" />
            <div className="w-2 h-2 rounded-sm bg-forge-fire" />
            <span>More</span>
          </div>
        </section>

        {/* Performance Chart */}
        <section className="bg-surface-dark/40 backdrop-blur-md border border-white/5 rounded-3xl p-5 shadow-lg mb-8">
          <div className="flex justify-between items-center mb-6">
            <h2 className="text-sm font-bold text-white uppercase tracking-wider">
              Performance
            </h2>
            <div className="flex gap-2 text-[10px]">
              <div className="flex items-center gap-1">
                <span className="w-2 h-2 rounded-full bg-forge-fire" />
                <span className="text-text-muted">FP Earned</span>
              </div>
              <div className="flex items-center gap-1">
                <span className="w-2 h-2 rounded-full bg-white/20" />
                <span className="text-text-muted">Practice Time</span>
              </div>
            </div>
          </div>
          <div className="h-32 w-full flex items-end justify-between gap-2 px-1">
            {['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day, idx) => {
              const primaryHeight = Math.random() * 80 + 20;
              const secondaryHeight = Math.random() * 60 + 10;
              const isActive = idx === 3;
              return (
                <div key={idx} className="flex-1 flex flex-col justify-end gap-1 group">
                  <div
                    className={`w-full bg-forge-fire rounded-t-sm group-hover:opacity-80 transition-opacity ${isActive ? 'shadow-[0_0_20px_rgba(255,69,0,0.5)]' : ''}`}
                    style={{ height: `${primaryHeight}%` }}
                  />
                  <div
                    className="w-full bg-white/20 rounded-t-sm group-hover:opacity-80 transition-opacity"
                    style={{ height: `${secondaryHeight}%` }}
                  />
                  <span className={`text-[9px] text-center mt-1 ${isActive ? 'text-white font-bold' : 'text-text-muted'}`}>
                    {day}
                  </span>
                </div>
              );
            })}
          </div>
        </section>
      </div>
    </main>
  );
};
