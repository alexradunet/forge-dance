import { Icon } from './Icon';

interface ButtonProps {
  children: React.ReactNode;
  variant?: 'primary' | 'secondary' | 'ghost' | 'danger';
  size?: 'sm' | 'md' | 'lg';
  icon?: string;
  iconPosition?: 'left' | 'right';
  className?: string;
  onClick?: () => void;
  disabled?: boolean;
}

export const Button = ({
  children,
  variant = 'primary',
  size = 'md',
  icon,
  iconPosition = 'left',
  className = '',
  onClick,
  disabled = false
}: ButtonProps) => {
  const baseStyles = 'font-bold uppercase tracking-wide transition-all active:scale-95 flex items-center justify-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed';
  
  const variantStyles = {
    primary: 'bg-forge-fire hover:bg-orange-600 text-white shadow-[0_4px_14px_rgba(255,69,0,0.4)]',
    secondary: 'bg-white/5 hover:bg-white/10 text-white border border-white/10',
    ghost: 'bg-transparent hover:bg-white/5 text-text-muted hover:text-white',
    danger: 'bg-red-600 hover:bg-red-500 text-white shadow-[0_4px_14px_rgba(239,68,68,0.4)]'
  };
  
  const sizeStyles = {
    sm: 'h-10 px-4 text-xs rounded-lg',
    md: 'h-14 px-6 text-sm rounded-xl',
    lg: 'h-16 px-8 text-lg rounded-2xl'
  };
  
  return (
    <button
      className={`${baseStyles} ${variantStyles[variant]} ${sizeStyles[size]} ${className}`}
      onClick={onClick}
      disabled={disabled}
    >
      {icon && iconPosition === 'left' && <Icon name={icon} className="text-xl" />}
      {children}
      {icon && iconPosition === 'right' && <Icon name={icon} className="text-xl" />}
    </button>
  );
};
