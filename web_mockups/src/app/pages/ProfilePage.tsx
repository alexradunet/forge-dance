import { Avatar } from '@/app/components/atoms/Avatar';
import { Badge } from '@/app/components/atoms/Badge';
import { Icon } from '@/app/components/atoms/Icon';
import { Header } from '@/app/components/organisms/Header';

interface ProfilePageProps {
  onNavigate?: (page: string) => void;
}

export const ProfilePage = ({ onNavigate }: ProfilePageProps) => {
  return (
    <main className="flex-1 flex flex-col z-10 overflow-hidden relative w-full max-w-md mx-auto">
      {/* Background gradient effects */}
      <div className="absolute top-0 left-0 w-full h-full overflow-hidden pointer-events-none z-0">
        <div className="absolute top-[-15%] right-[-20%] w-[400px] h-[400px] bg-forge-fire/10 rounded-full blur-[100px]" />
        <div className="absolute bottom-[-10%] left-[-10%] w-[300px] h-[300px] bg-electric-blue/5 rounded-full blur-[80px]" />
      </div>

      <Header 
        title="PROFILE" 
        rightSlot={
          <button 
            onClick={() => onNavigate?.('settings')}
            className="w-10 h-10 flex items-center justify-center rounded-full hover:bg-white/10 transition-colors text-text-muted hover:text-white"
          >
            <Icon name="settings" className="text-2xl" />
          </button>
        }
      />

      <div className="flex-1 overflow-y-auto overflow-x-hidden scrollbar-hide pb-32 relative z-10">
        {/* Avatar Section */}
        <div className="bg-surface-card border border-white/5 rounded-2xl p-6 shadow-lg mx-6 mt-6 mb-8">
          <div className="flex flex-col items-center relative">
            <div className="relative group">
              <div className="absolute -inset-1.5 rounded-full bg-gradient-to-tr from-forge-fire via-orange-500 to-transparent opacity-80 animate-pulse" />
              <div className="absolute -inset-1.5 rounded-full blur-md bg-forge-fire/30" />
              <Avatar
                src="https://ui-avatars.com/api/?name=Alex+Chen&background=FF4500&color=fff&size=256"
                alt="Alex Chen"
                size="xl"
                className="relative z-10"
              />
              <div className="absolute -bottom-3 left-1/2 -translate-x-1/2 z-20">
                <Badge className="shadow-lg border-2 border-bg-deep flex items-center gap-1">
                  <Icon name="local_fire_department" className="text-[14px] filled" />
                  Legend
                </Badge>
              </div>
            </div>
            <h2 className="mt-5 text-xl font-bold text-white tracking-tight">
              Alex "Pulse" Chen
            </h2>
            <p className="text-xs text-text-muted mt-0.5 font-mono">Lvl 42 • Pro Dancer</p>
          </div>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-3 gap-3 px-6 mb-10">
          <div className="bg-surface-dark/80 backdrop-blur-sm border border-white/5 rounded-2xl p-3 flex flex-col items-center justify-center gap-1 shadow-lg">
            <span className="text-[10px] uppercase text-text-muted tracking-widest font-bold">
              Streak
            </span>
            <div className="flex items-center gap-1 text-white">
              <Icon name="local_fire_department" filled className="text-forge-fire text-sm" />
              <span className="font-mono text-lg font-bold">128</span>
            </div>
          </div>
          <div className="bg-surface-dark/80 backdrop-blur-sm border border-white/5 rounded-2xl p-3 flex flex-col items-center justify-center gap-1 shadow-lg">
            <span className="text-[10px] uppercase text-text-muted tracking-widest font-bold">
              Total FP
            </span>
            <div className="flex items-center gap-1 text-white">
              <Icon name="bolt" filled className="text-electric-blue text-sm" />
              <span className="font-mono text-lg font-bold">14k</span>
            </div>
          </div>
          <div className="bg-surface-dark/80 backdrop-blur-sm border border-white/5 rounded-2xl p-3 flex flex-col items-center justify-center gap-1 shadow-lg">
            <span className="text-[10px] uppercase text-text-muted tracking-widest font-bold">
              Rank
            </span>
            <div className="flex items-center gap-1 text-white">
              <Icon name="emoji_events" filled className="text-yellow-400 text-sm" />
              <span className="font-mono text-lg font-bold">#08</span>
            </div>
          </div>
        </div>

        {/* Achievements */}
        <div className="mb-10 pl-6">
          <div className="flex justify-between items-end pr-6 mb-4">
            <h3 className="font-title text-xl text-white tracking-wide">
              My Achievements
            </h3>
            <button 
              onClick={() => onNavigate?.('achievements')}
              className="text-[10px] text-forge-fire hover:text-white transition-colors uppercase font-bold tracking-widest"
            >
              View All
            </button>
          </div>
          <div className="flex gap-4 overflow-x-auto pb-4 pr-6 scrollbar-hide">
            {['Groove Master', 'Perfect Week', 'Inferno Streak'].map((achievement) => (
              <div key={achievement} className="flex-shrink-0 w-24 flex flex-col items-center gap-2 group cursor-pointer">
                <div className="w-20 h-20 rounded-full bg-gradient-to-b from-surface-dark to-black border border-white/10 flex items-center justify-center relative group-hover:border-forge-fire/50 transition-colors shadow-lg">
                  <div className="absolute inset-0 bg-yellow-500/10 rounded-full blur-xl opacity-0 group-hover:opacity-100 transition-opacity" />
                  <Icon name="stars" filled className="text-4xl text-yellow-400 drop-shadow-[0_0_10px_rgba(250,204,21,0.5)]" />
                </div>
                <span className="text-[10px] text-center text-text-muted font-medium w-full truncate">
                  {achievement}
                </span>
              </div>
            ))}
            <div className="flex-shrink-0 w-24 flex flex-col items-center gap-2 opacity-50 grayscale">
              <div className="w-20 h-20 rounded-full bg-surface-dark border border-white/5 flex items-center justify-center relative">
                <Icon name="lock" className="text-4xl text-white/20" />
              </div>
              <span className="text-[10px] text-center text-white/30 font-medium w-full truncate">
                Rhythm King
              </span>
            </div>
          </div>
        </div>

      </div>
    </main>
  );
};