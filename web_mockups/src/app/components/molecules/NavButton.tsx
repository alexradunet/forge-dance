import { Icon } from '@/app/components/atoms/Icon';

interface NavButtonProps {
  icon: string;
  label: string;
  active?: boolean;
  onClick?: () => void;
  className?: string;
}

export const NavButton = ({ 
  icon, 
  label, 
  active = false, 
  onClick,
  className = '' 
}: NavButtonProps) => {
  return (
    <button
      onClick={onClick}
      className={`
        flex-1 flex flex-col items-center gap-1 transition-all duration-300 
        hover:scale-105 active:scale-95 pb-1
        ${active ? 'text-forge-fire' : 'text-text-muted hover:text-white'}
        ${className}
      `}
    >
      <Icon 
        name={icon} 
        filled={active}
        className="text-[26px]" 
      />
      <span className={`text-[10px] tracking-wide ${active ? 'font-bold' : 'font-medium'}`}>
        {label}
      </span>
      <span 
        className={`
          w-1 h-1 rounded-full mt-1 transition-opacity
          ${active ? 'bg-forge-fire opacity-100 shadow-[0_0_10px_rgba(255,69,0,0.5)]' : 'opacity-0'}
        `} 
      />
    </button>
  );
};
