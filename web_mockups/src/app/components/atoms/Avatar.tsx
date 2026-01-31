interface AvatarProps {
  src?: string;
  alt?: string;
  size?: 'sm' | 'md' | 'lg' | 'xl';
  online?: boolean;
  level?: number;
  className?: string;
}

export const Avatar = ({ 
  src = 'https://ui-avatars.com/api/?name=User&background=FF4500&color=fff',
  alt = 'User Avatar',
  size = 'md',
  online = false,
  level,
  className = ''
}: AvatarProps) => {
  const sizeStyles = {
    sm: 'w-10 h-10',
    md: 'w-16 h-16',
    lg: 'w-20 h-20',
    xl: 'w-32 h-32'
  };
  
  return (
    <div className={`relative inline-block ${className}`}>
      <div className={`${sizeStyles[size]} rounded-full overflow-hidden ring-2 ring-white/20`}>
        <img 
          src={src} 
          alt={alt} 
          className="w-full h-full object-cover"
        />
      </div>
      
      {online && (
        <div className="absolute bottom-1 right-1 w-3 h-3 bg-green-500 border-2 border-bg-deep rounded-full" />
      )}
      
      {level && (
        <div className="absolute -top-1 -right-1 w-6 h-6 bg-forge-fire rounded-full flex items-center justify-center border-2 border-bg-deep text-[10px] font-black text-white">
          {level}
        </div>
      )}
    </div>
  );
};
