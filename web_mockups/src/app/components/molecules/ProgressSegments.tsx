import { cn } from '@/lib/utils';
import { motion } from 'motion/react';

interface ProgressSegmentsProps {
  total: number;
  current: number; // 0-indexed
  className?: string;
}

export function ProgressSegments({ total, current, className }: ProgressSegmentsProps) {
  return (
    <div className={cn("flex w-full items-center justify-center gap-2 px-6 py-2 z-10", className)}>
      {Array.from({ length: total }).map((_, index) => {
        const isActive = index === current;
        const isPast = index < current;
        
        return (
          <div 
            key={index} 
            className="h-1.5 flex-1 relative"
          >
            {/* Background track */}
            <div className="absolute inset-0 rounded-full bg-slate-300 dark:bg-white/20" />
            
            {/* Active/Past indicator */}
            {(isActive || isPast) && (
              <motion.div 
                initial={{ width: "0%" }}
                animate={{ width: "100%" }}
                className={cn(
                  "absolute inset-0 rounded-full",
                  isActive ? "bg-primary shadow-[0_0_8px_rgba(242,74,13,0.5)]" : "bg-slate-300 dark:bg-white/20" // Past segments usually look like completed or just neutral? 
                  // In the HTML example:
                  // Active: bg-primary shadow
                  // Others: bg-slate-300 dark:bg-white/20
                  // So essentially, only the ACTIVE one is highlighted in the example.
                  // But standard progress usually fills past ones. 
                  // Example 2 HTML: One active (middle), others inactive.
                  // Example 3 HTML: First active, others inactive.
                  // I will stick to the example logic: Only highlight the current one? 
                  // Wait, "Module 3" example shows 3rd bar is primary, 1,2,4,5 are grey.
                  // "Module 4" example shows 1st bar is primary.
                  // So it acts more like a "step indicator" than a cumulative progress bar.
                )}
              />
            )}
            
            {/* If strictly following the HTML example where only current is colored: */}
            {isActive && (
               <div className="absolute inset-0 rounded-full bg-primary shadow-[0_0_8px_rgba(242,74,13,0.5)]" />
            )}
          </div>
        );
      })}
    </div>
  );
}
