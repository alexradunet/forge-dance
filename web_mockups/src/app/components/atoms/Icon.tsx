interface IconProps {
  name: string;
  className?: string;
  filled?: boolean;
}

export const Icon = ({ name, className = '', filled = false }: IconProps) => {
  return (
    <span className={`material-symbols-outlined ${filled ? 'filled' : ''} ${className}`}>
      {name}
    </span>
  );
};
