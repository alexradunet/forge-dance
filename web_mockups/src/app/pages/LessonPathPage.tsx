import { Icon } from '@/app/components/atoms/Icon';
import { Header } from '@/app/components/organisms/Header';

interface LessonPathPageProps {
  onNavigate?: (tab: string) => void;
}

export const LessonPathPage = ({ onNavigate }: LessonPathPageProps) => {
  return (
    <div className="w-full h-full flex flex-col relative z-10 bg-bg-deep/50 backdrop-blur-sm border-x border-white/5 min-h-screen">
      {/* Header */}
      <Header 
        title="Hip Hop Foundations" 
        subtitle="Module 1 • Path" 
        leftSlot={
          <button 
            onClick={() => onNavigate?.('explore')}
            className="w-10 h-10 flex items-center justify-center rounded-full bg-surface-dark border border-white/10 hover:bg-white/10 transition-colors"
          >
            <Icon name="arrow_back" className="text-text-muted text-xl" />
          </button>
        }
        rightSlot={
          <button className="w-10 h-10 flex items-center justify-center rounded-full bg-surface-dark border border-white/10 hover:bg-white/10 transition-colors">
            <Icon name="more_vert" className="text-text-muted text-xl" />
          </button>
        }
      />

      {/* Main Content */}
      <main className="flex-1 overflow-y-auto no-scrollbar relative px-6 py-8">
        {/* Timeline Line */}
        <div className="absolute left-1/2 top-0 bottom-0 w-[2px] bg-white/5 -translate-x-1/2 z-0"></div>
        <div className="absolute left-1/2 top-0 h-[220px] w-[2px] bg-gradient-to-b from-primary/80 to-primary -translate-x-1/2 z-0 shadow-[0_0_10px_rgba(255,69,0,0.5)]"></div>

        <div className="relative z-10 flex flex-col items-center gap-12 pb-12">
          
          {/* Item 1: Theory (Completed) */}
          <div className="w-full flex items-center justify-center relative group">
            <div className="absolute right-[55%] pr-6 text-right w-1/2">
              <span className="text-[10px] font-bold text-primary tracking-widest uppercase block mb-1">Theory</span>
              <h3 className="text-sm font-bold text-white leading-tight opacity-80 group-hover:opacity-100 transition-opacity">History of Hip Hop</h3>
            </div>
            <div className="w-10 h-10 rounded-full bg-bg-deep border-[3px] border-primary flex items-center justify-center shadow-glow-primary z-20 relative">
              <Icon name="check" className="text-primary text-[20px] font-bold" />
            </div>
            <div className="absolute left-[55%] pl-6 w-1/2 pointer-events-none"></div>
          </div>

          {/* Item 2: Movement (Current Lesson) */}
          <div className="w-full relative">
            <div className="absolute left-1/2 top-0 bottom-0 w-[2px] bg-primary -translate-x-1/2 z-0 opacity-50"></div>
            
            <div 
              onClick={() => onNavigate?.('ignite')}
              className="bg-surface-card border border-primary rounded-2xl p-0 shadow-glow-intense relative overflow-hidden w-full max-w-[320px] mx-auto z-20 group cursor-pointer transition-transform duration-300 active:scale-95"
            >
              <div className="h-32 bg-gradient-to-br from-[#2a1005] to-[#121212] relative overflow-hidden">
                <div className="absolute -right-4 -top-8 w-40 h-40 bg-primary/20 rounded-full blur-[40px]"></div>
                <div 
                  className="absolute left-0 bottom-0 w-full h-full bg-cover bg-center opacity-40 mix-blend-overlay"
                  style={{ backgroundImage: `url('https://images.unsplash.com/photo-1535525153412-5a42439a210d?q=80&w=2070&auto=format&fit=crop')` }}
                ></div>
                <div className="absolute top-3 left-3 bg-primary/90 backdrop-blur text-white text-[10px] font-bold px-2 py-1 rounded shadow-md uppercase tracking-wider flex items-center gap-1">
                  <span className="w-1.5 h-1.5 bg-white rounded-full animate-pulse"></span>
                  Current Lesson
                </div>
              </div>
              
              <div className="p-4 relative">
                <div className="absolute -top-6 right-4 w-12 h-12 rounded-full bg-primary text-white shadow-lg shadow-primary/40 flex items-center justify-center border-4 border-surface-card group-hover:scale-110 transition-transform duration-300">
                  <Icon name="play_arrow" className="text-[24px] ml-0.5 filled" />
                </div>
                <span className="text-[10px] font-bold text-primary/80 tracking-widest uppercase mb-1 block">Movement</span>
                <h2 className="text-2xl font-title text-white leading-none mb-1">Groove Basics</h2>
                <div className="flex items-center gap-3 text-text-muted text-[11px] font-medium mt-2">
                  <span className="flex items-center gap-1"><Icon name="schedule" className="text-[14px]" /> 15 min</span>
                  <span className="w-0.5 h-3 bg-white/10"></span>
                  <span className="flex items-center gap-1"><Icon name="bar_chart" className="text-[14px]" /> Beginner</span>
                </div>
                <div className="mt-4 pt-4 border-t border-white/5 flex items-center justify-between">
                  <span className="text-[11px] text-text-muted">Progress</span>
                  <span className="text-[11px] font-bold text-white">0%</span>
                </div>
                <div className="h-1 w-full bg-white/10 rounded-full mt-2 overflow-hidden">
                  <div className="h-full w-0 bg-primary rounded-full"></div>
                </div>
              </div>
            </div>
          </div>

          {/* Item 3: Drill (Locked) */}
          <div className="w-full flex items-center justify-center relative opacity-60">
            <div className="absolute right-[55%] pr-6 w-1/2 pointer-events-none"></div>
            <div className="w-10 h-10 rounded-full bg-bg-deep border-2 border-white/20 flex items-center justify-center z-20 relative">
              <Icon name="lock" className="text-text-muted text-[18px]" />
            </div>
            <div className="absolute left-[55%] pl-6 w-1/2">
              <span className="text-[10px] font-bold text-text-muted tracking-widest uppercase block mb-1">Drill</span>
              <h3 className="text-sm font-medium text-text-muted leading-tight">Bounce & Rock</h3>
            </div>
          </div>

          {/* Item 4: Experiment (Locked) */}
          <div className="w-full flex items-center justify-center relative opacity-60">
            <div className="absolute right-[55%] pr-6 text-right w-1/2">
              <span className="text-[10px] font-bold text-text-muted tracking-widest uppercase block mb-1">Experiment</span>
              <h3 className="text-sm font-medium text-text-muted leading-tight">Freestyle Session</h3>
            </div>
            <div className="w-10 h-10 rounded-full bg-bg-deep border-2 border-white/20 flex items-center justify-center z-20 relative">
              <Icon name="lock" className="text-text-muted text-[18px]" />
            </div>
            <div className="absolute left-[55%] pl-6 w-1/2 pointer-events-none"></div>
          </div>

          {/* Connector to Final */}
          <div className="h-8 w-[2px] bg-gradient-to-b from-white/5 to-transparent"></div>

          {/* Item 5: Boss Showcase */}
          <div className="flex flex-col items-center justify-center z-20 mt-2">
            <div className="relative group cursor-pointer">
              <div className="absolute inset-0 bg-gold/20 rounded-full blur-[20px] animate-pulse"></div>
              <div className="w-20 h-20 bg-gradient-to-br from-surface-dark to-black border border-gold/40 rounded-full flex items-center justify-center shadow-glow-gold relative overflow-hidden group-hover:scale-105 transition-transform duration-300">
                <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_top,_var(--tw-gradient-stops))] from-gold/10 via-transparent to-transparent"></div>
                <Icon name="emoji_events" className="text-gold text-[36px] drop-shadow-md" />
              </div>
              <div className="absolute -bottom-1 -right-1 w-6 h-6 bg-surface-dark rounded-full flex items-center justify-center border border-white/10">
                <Icon name="lock" className="text-text-muted text-[14px]" />
              </div>
            </div>
            <div className="text-center mt-4 space-y-1">
              <span className="text-[10px] font-bold text-gold tracking-[0.2em] uppercase block drop-shadow-sm">Final Challenge</span>
              <h2 className="font-title text-3xl text-white tracking-wide">Boss Showcase</h2>
              <p className="text-[10px] text-text-muted max-w-[150px] mx-auto leading-relaxed">Combine all elements to unlock the next module.</p>
            </div>
          </div>

          <div className="h-16"></div>
        </div>
      </main>

      {/* FAB */}
      <div className="absolute bottom-6 right-6 z-40">
        <button className="w-12 h-12 bg-white/5 hover:bg-white/10 backdrop-blur-md rounded-full flex items-center justify-center text-white border border-white/10 shadow-lg transition-all">
          <Icon name="my_location" className="text-[20px]" />
        </button>
      </div>
      
      {/* Footer Text */}
      <footer className="fixed bottom-24 left-0 right-0 text-center text-text-muted/20 text-[10px] uppercase tracking-widest w-full pointer-events-none z-0">
        <p>Forge.Dance • Lesson Path Variant 3</p>
      </footer>
    </div>
  );
};
