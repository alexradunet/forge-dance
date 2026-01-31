import { Header } from '@/app/components/organisms/Header';
import { ModuleCardHero } from '@/app/components/molecules/ModuleCardHero';
import { Icon } from '@/app/components/atoms/Icon';
import { WorkoutStartAnimation } from '@/app/components/organisms/WorkoutStartAnimation';
import { useState } from 'react';

interface WorkoutPageProps {
  onNavigate?: (tab: string) => void;
}

export const WorkoutPage = ({ onNavigate }: WorkoutPageProps) => {
  const [showAnimation, setShowAnimation] = useState(false);

  const handleStartWorkout = () => {
    setShowAnimation(true);
  };

  const handleAnimationComplete = () => {
    setShowAnimation(false);
    onNavigate?.('training-session');
  };

  return (
    <>
      {showAnimation && (
        <WorkoutStartAnimation onComplete={handleAnimationComplete} />
      )}
      
      <main className="w-full flex-1 flex flex-col relative overflow-y-auto scrollbar-hide pb-24">
        <Header
          title="Workout"
          subtitle="Of The Day"
          onBack={() => onNavigate?.('home')}
        />

        <div className="px-6 py-4 space-y-8">
          {/* Today's WOD */}
          <section>
            <ModuleCardHero
              title="EXPLOSIVE POWER"
              description="High intensity interval training focused on lower body strength and explosive jumps."
              category="HIIT • 45 Min"
              duration="45 Min"
              imageUrl="https://images.unsplash.com/photo-1518611012118-696072aa579a?w=800&auto=format&fit=crop&q=80"
              onStart={handleStartWorkout}
            />
          </section>

          {/* Weekly Plan */}
          <section>
            <div className="flex justify-between items-end mb-4">
              <h3 className="font-title text-lg text-white tracking-wide">Today's Workout</h3>
              <span className="text-xs text-text-muted">5 Steps • 30 Min</span>
            </div>
            
            <div className="space-y-3">
              {[
                { step: '1', title: 'Dynamic Stretching', duration: '5 min', type: 'warmup', icon: 'whatshot' },
                { step: '2', title: 'Hip Opener Flow', duration: '7 min', type: 'exercise', icon: 'fitness_center' },
                { step: '3', title: 'Core Stability', duration: '6 min', type: 'exercise', icon: 'fitness_center' },
                { step: '4', title: 'Isolation Drills', duration: '8 min', type: 'exercise', icon: 'fitness_center' },
                { step: '5', title: 'Cool Down Stretch', duration: '4 min', type: 'cooldown', icon: 'self_improvement' },
              ].map((item, idx) => (
                <div key={idx} className="flex items-center p-3 rounded-xl border bg-surface-dark border-white/5 hover:border-white/10 transition-colors">
                  <div className={`w-10 h-10 rounded-xl flex items-center justify-center mr-3 ${
                    item.type === 'warmup' ? 'bg-electric-blue/10 text-electric-blue' :
                    item.type === 'cooldown' ? 'bg-mystic-purple/10 text-mystic-purple' :
                    'bg-forge-fire/10 text-forge-fire'
                  }`}>
                    <Icon name={item.icon} className="text-lg" />
                  </div>
                  <div className="flex-1">
                    <div className="text-sm font-bold text-white">{item.title}</div>
                    <div className="text-[10px] text-text-muted uppercase tracking-wider">
                      {item.type} • {item.duration}
                    </div>
                  </div>
                  <div className="text-xs font-bold text-text-muted">
                    {item.duration}
                  </div>
                </div>
              ))}
            </div>
          </section>
        </div>
      </main>
    </>
  );
};