import { Header } from '@/app/components/organisms/Header';
import { LessonNode } from '@/app/components/molecules/LessonNode';
import { PaginationDot } from '@/app/components/atoms/PaginationDot';
import { Icon } from '@/app/components/atoms/Icon';
import { Badge } from '@/app/components/atoms/Badge';
import { Button } from '@/app/components/atoms/Button';

export const LearningPathPage = () => {
  return (
    <div className="relative min-h-screen w-full flex flex-col max-w-[430px] mx-auto bg-bg-deep overflow-hidden">
      <Header
        title="Hip Hop Foundations"
        subtitle="Module 1 • Path"
        onBack={() => console.log('Back')}
        onMore={() => console.log('More')}
      />

      {/* Progress Indicator */}
      <div className="flex gap-1 h-1 w-full px-8 py-2">
        <div className="flex-1 bg-forge-fire rounded-full" />
        <div className="flex-1 bg-forge-fire rounded-full" />
        <div className="flex-1 bg-white/20 rounded-full" />
        <div className="flex-1 bg-white/10 rounded-full" />
        <div className="flex-1 bg-white/10 rounded-full" />
      </div>

      <main className="flex-1 relative overflow-y-auto px-6 pt-8 pb-20 scrollbar-hide">
        {/* Background Grid Pattern */}
        <div className="absolute inset-0 opacity-20 pointer-events-none" style={{
          backgroundImage: 'linear-gradient(to right, #1a1a1a 1px, transparent 1px), linear-gradient(to bottom, #1a1a1a 1px, transparent 1px)',
          backgroundSize: '32px 32px'
        }} />

        <div className="relative flex flex-col items-center">
          {/* Path Line */}
          <div className="absolute left-1/2 -translate-x-1/2 w-0.5 h-full bg-gradient-to-b from-forge-fire via-forge-fire/50 to-white/10" />

          {/* Completed Lesson */}
          <div className="relative flex flex-col items-center group mb-16 z-10">
            <LessonNode
              title="History of Bounce"
              type="theory"
              status="completed"
              duration="15 min"
            />
          </div>

          {/* Active Lesson with Card */}
          <div className="relative flex flex-col items-center mb-16 z-10">
            <LessonNode
              title="Groove Basics"
              type="movement"
              status="active"
              duration="25 min"
            />
            <div className="mt-6 w-[280px] bg-surface-dark border border-white/10 rounded-2xl p-4 shadow-2xl">
              <div className="flex items-center gap-3 mb-2">
                <Badge variant="primary">Current Lesson</Badge>
                <div className="flex-1 h-px bg-white/5" />
              </div>
              <h2 className="font-title text-3xl text-white tracking-wide leading-none mb-1">
                GROOVE BASICS
              </h2>
              <p className="text-text-muted text-xs font-medium mb-4">
                Lorem ipsum dolor sit amet, consectetur adipiscing elit
              </p>
              <Button size="md" className="w-full" icon="play_arrow" iconPosition="left">
                Start Practice
              </Button>
            </div>
          </div>

          {/* Locked Lessons */}
          <div className="relative flex flex-col items-center mb-16 z-10">
            <LessonNode
              title="Timing Drill"
              type="drill"
              status="locked"
              duration="20 min"
            />
          </div>

          <div className="relative flex flex-col items-center mb-24 z-10">
            <LessonNode
              title="Flow Lab"
              type="experiment"
              status="locked"
              duration="30 min"
            />
          </div>

          {/* Boss Challenge */}
          <div className="relative flex flex-col items-center pb-12 z-10">
            <div className="relative z-10 group">
              <div className="w-24 h-24 rotate-45 bg-zinc-900 border-4 border-dashed border-white/10 flex items-center justify-center overflow-hidden">
                <div className="rotate-[-45deg] flex flex-col items-center">
                  <Icon name="emoji_events" className="text-white/20 text-4xl" />
                </div>
              </div>
              <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
                <div className="w-24 h-24 bg-white/5 blur-xl rounded-full" />
              </div>
            </div>
            <div className="mt-8 text-center">
              <span className="text-[10px] font-bold uppercase tracking-[0.2em] text-white/30 mb-2 block">
                The Forge Finale
              </span>
              <h2 className="font-title text-4xl text-white/20 tracking-widest">
                BOSS SHOWCASE
              </h2>
              <p className="text-xs text-text-muted mt-2">
                Lorem ipsum dolor sit amet, consectetur adipiscing elit
              </p>
            </div>
          </div>
        </div>
      </main>

      {/* Bottom Nav Simplified */}
      <nav className="bg-bg-deep/90 backdrop-blur-xl border-t border-white/5 pb-8 pt-3 px-8">
        <div className="flex justify-between items-center max-w-sm mx-auto">
          <div className="flex flex-col items-center gap-1 text-forge-fire">
            <Icon name="map" />
            <span className="text-[10px] font-bold">Path</span>
          </div>
          <div className="flex flex-col items-center gap-1 text-white/40">
            <Icon name="bolt" />
            <span className="text-[10px] font-bold">Drills</span>
          </div>
          <div className="flex flex-col items-center gap-1 text-white/40">
            <Icon name="group" />
            <span className="text-[10px] font-bold">Battle</span>
          </div>
          <div className="flex flex-col items-center gap-1 text-white/40">
            <Icon name="person" />
            <span className="text-[10px] font-bold">Profile</span>
          </div>
        </div>
      </nav>
    </div>
  );
};
