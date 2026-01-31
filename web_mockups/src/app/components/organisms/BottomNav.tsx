import { NavButton } from '@/app/components/molecules/NavButton';
import { Icon } from '@/app/components/atoms/Icon';

interface BottomNavProps {
  activeTab: string;
  onTabChange: (tab: string) => void;
  className?: string;
}

export const BottomNav = ({ activeTab, onTabChange, className = '' }: BottomNavProps) => {
  return (
    <nav className={`
      fixed bottom-0 left-0 w-full z-50 px-2 pb-4 pt-4 pointer-events-none
      ${className}
    `}>
      <div className="max-w-[500px] mx-auto pointer-events-auto">
        <div className="h-[65px] bg-surface-dark/95 backdrop-blur-2xl border-t border-white/10 flex items-end justify-between px-6 pb-2 -mx-2 -mb-4 relative [&_button>span:last-child]:hidden">
          <NavButton
            icon="favorite"
            label="Collection"
            active={activeTab === 'collection'}
            onClick={() => onTabChange('collection')}
          />
          
          <NavButton
            icon="school"
            label="Learn"
            active={activeTab === 'learn'}
            onClick={() => onTabChange('learn')}
          />
          
          <NavButton
            icon="home"
            label="Home"
            active={activeTab === 'home'}
            onClick={() => onTabChange('home')}
          />
          
          <NavButton
            icon="fitness_center"
            label="Workout"
            active={activeTab === 'workout'}
            onClick={() => onTabChange('workout')}
          />
          
          <NavButton
            icon="person"
            label="Profile"
            active={activeTab === 'profile'}
            onClick={() => onTabChange('profile')}
          />
        </div>
      </div>
    </nav>
  );
};
