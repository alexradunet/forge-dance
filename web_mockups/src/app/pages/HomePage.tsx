import { ModuleCardHero } from "@/app/components/molecules/ModuleCardHero";
import { ModuleCard } from "@/app/components/molecules/ModuleCard";
import { ModuleCardLarge } from "@/app/components/molecules/ModuleCardLarge";
import { ModuleCardSmall } from "@/app/components/molecules/ModuleCardSmall";
import { ProgressBar } from "@/app/components/atoms/ProgressBar";
import { Icon } from "@/app/components/atoms/Icon";
import { Header } from "@/app/components/organisms/Header";

export const HomePage = ({
  onNavigate,
}: {
  onNavigate?: (tab: string) => void;
}) => {
  return (
    <main className="w-full flex-1 flex flex-col relative z-10 overflow-y-auto scrollbar-hide">
      {/* Header */}
      <Header
        title="ALEX_DANCER"
        subtitle="Welcome Back"
        rightSlot={
          <div className="w-10 h-10 rounded-full bg-surface-dark border border-white/10 flex items-center justify-center relative cursor-pointer hover:bg-white/10 transition-colors">
            <Icon
              name="notifications"
              className="text-white text-[20px]"
            />
            <span className="absolute top-2 right-2.5 w-2 h-2 bg-forge-fire rounded-full border border-bg-deep" />
          </div>
        }
      />

      {/* Hero Section - Today's WOD */}
      <section className="px-6 mt-2">
        <ModuleCardHero
          title="EXPLOSIVE POWER"
          description="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore."
          category="Today's WOD"
          duration="45 Min"
          imageUrl="https://images.unsplash.com/photo-1518611012118-696072aa579a?w=800&auto=format&fit=crop&q=80"
          onStart={() => onNavigate?.("workout")}
        />
      </section>

      {/* Progress Section */}
      <section className="px-6 mt-8">
        <div className="flex justify-between items-end mb-4">
          <h3 className="font-title text-xl tracking-wide text-white">
            MY PROGRESS
          </h3>
        </div>

        <div className="bg-surface-card border border-white/5 rounded-2xl p-5 shadow-lg">
          <div className="flex justify-between items-center mb-4">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-full bg-surface-dark flex items-center justify-center border border-white/5">
                <Icon
                  name="local_fire_department"
                  className="text-forge-fire text-[20px]"
                />
              </div>
              <div>
                <div className="text-sm font-bold text-white">
                  Day 12
                </div>
                <div className="text-[10px] text-text-muted uppercase tracking-wider">
                  Current Streak
                </div>
              </div>
            </div>
            <div className="text-right">
              <div className="text-sm font-bold text-white">
                Level 4
              </div>
              <div className="text-[10px] text-text-muted uppercase tracking-wider">
                Intermediate
              </div>
            </div>
          </div>

          <ProgressBar
            value={1240}
            max={1500}
            variant="primary"
            showLabel
          />
          <div className="flex justify-between text-[10px] text-text-muted font-medium mt-1">
            <span>1,240 XP</span>
            <span>Next Level: 1,500 XP</span>
          </div>
        </div>
      </section>

      {/* Continue Training Section */}
      <section className="mt-8">
        <div className="px-6 flex justify-between items-end mb-4">
          <h3 className="font-title text-xl tracking-wide text-white">
            CONTINUE TRAINING
          </h3>
        </div>
        <div className="flex overflow-x-auto gap-4 px-6 pb-4 scrollbar-hide snap-x">
          <ModuleCardLarge
            title="Hip Opener Flow"
            category="Mobility"
            categoryColor="primary"
            progress={65}
            lessons={{ completed: 5, total: 8 }}
            imageUrl="https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=400&auto=format&fit=crop&q=80"
            badge="Resume"
          />
          <ModuleCardLarge
            title="Isolation Drills"
            category="Body Control"
            categoryColor="success"
            progress={40}
            lessons={{ completed: 3, total: 7 }}
            imageUrl="https://images.unsplash.com/photo-1508700929628-666bc8bd84ea?w=400&auto=format&fit=crop&q=80"
            badge="Resume"
          />
        </div>
      </section>

      {/* Recommended For You */}
      <section className="mt-8 mb-4">
        <div className="px-6 flex justify-between items-end mb-4">
          <h3 className="font-title text-xl tracking-wide text-white">
            RECOMMENDED FOR YOU
          </h3>
          <span
            className="text-forge-fire text-xs font-bold uppercase tracking-wider cursor-pointer hover:text-forge-fire/80 transition-colors"
            onClick={() => onNavigate?.("learn")}
          >
            View All
          </span>
        </div>
        <div className="flex overflow-x-auto gap-4 px-6 pb-4 scrollbar-hide snap-x">
          <ModuleCardSmall
            title="Footwork Fundamentals"
            category="Technique"
            categoryColor="success"
            progress={0}
            lessons={{ completed: 0, total: 6 }}
            imageUrl="https://images.unsplash.com/photo-1716996642138-e655f2a8dcd5?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1080"
          />
          <ModuleCardSmall
            title="Breaking Basics"
            category="Power Moves"
            categoryColor="info"
            progress={0}
            lessons={{ completed: 0, total: 7 }}
            imageUrl="https://images.unsplash.com/photo-1506411393232-79727bc447af?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1080"
          />
          <ModuleCardSmall
            title="Rhythm & Groove"
            category="Musicality"
            categoryColor="primary"
            progress={0}
            lessons={{ completed: 0, total: 5 }}
            imageUrl="https://images.unsplash.com/photo-1504609813442-a8924e83f76e?w=400&auto=format&fit=crop&q=80"
          />
        </div>
      </section>
    </main>
  );
};