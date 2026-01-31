import { useEffect, useState } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { Icon } from '@/app/components/atoms/Icon';

interface WorkoutStartAnimationProps {
  onComplete: () => void;
}

export const WorkoutStartAnimation = ({ onComplete }: WorkoutStartAnimationProps) => {
  const [phase, setPhase] = useState<'ready' | 'countdown' | 'go'>('ready');
  const [count, setCount] = useState(3);

  useEffect(() => {
    // Show "GET READY" for 1 second
    const readyTimer = setTimeout(() => {
      setPhase('countdown');
    }, 1000);

    return () => clearTimeout(readyTimer);
  }, []);

  useEffect(() => {
    if (phase === 'countdown') {
      if (count > 0) {
        const timer = setTimeout(() => {
          setCount(count - 1);
        }, 800);
        return () => clearTimeout(timer);
      } else {
        setPhase('go');
      }
    } else if (phase === 'go') {
      const goTimer = setTimeout(() => {
        onComplete();
      }, 1000);
      return () => clearTimeout(goTimer);
    }
  }, [phase, count, onComplete]);

  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      className="fixed inset-0 z-50 flex items-center justify-center bg-bg-deep"
    >
      {/* Animated background gradient */}
      <motion.div
        className="absolute inset-0 bg-gradient-radial from-forge-fire/20 via-bg-deep to-bg-deep"
        animate={{
          scale: [1, 1.2, 1],
          opacity: [0.3, 0.6, 0.3],
        }}
        transition={{
          duration: 2,
          repeat: Infinity,
          ease: 'easeInOut',
          type: 'tween',
        }}
      />

      {/* Pulsing circles */}
      <motion.div
        className="absolute inset-0 flex items-center justify-center"
        initial={{ scale: 0, opacity: 0 }}
        animate={{
          scale: [1, 2.5],
          opacity: [0.4, 0],
        }}
        transition={{
          duration: 1.5,
          repeat: Infinity,
          ease: 'easeOut',
        }}
      >
        <div className="w-64 h-64 rounded-full border-4 border-forge-fire" />
      </motion.div>

      <AnimatePresence mode="wait">
        {phase === 'ready' && (
          <motion.div
            key="ready"
            initial={{ scale: 0, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            exit={{ scale: 0.8, opacity: 0 }}
            transition={{ type: 'spring', stiffness: 200, damping: 20 }}
            className="relative z-10 text-center"
          >
            <motion.div
              animate={{
                rotate: [0, 10, -10, 0],
              }}
              transition={{
                duration: 0.5,
                repeat: 2,
              }}
            >
              <Icon
                name="local_fire_department"
                className="text-forge-fire text-[120px] mb-4"
              />
            </motion.div>
            <h1 className="font-title text-6xl text-white tracking-wider">
              GET READY
            </h1>
          </motion.div>
        )}

        {phase === 'countdown' && count > 0 && (
          <motion.div
            key={`count-${count}`}
            initial={{ scale: 0, opacity: 0, rotate: -180 }}
            animate={{ scale: 1, opacity: 1, rotate: 0 }}
            exit={{ scale: 2, opacity: 0 }}
            transition={{
              type: 'spring',
              stiffness: 200,
              damping: 15,
            }}
            className="relative z-10"
          >
            <motion.div
              animate={{
                scale: [1, 1.1],
              }}
              transition={{
                duration: 0.4,
                repeat: 1,
                repeatType: 'reverse',
              }}
              className="text-[200px] font-title text-forge-fire leading-none"
              style={{
                textShadow: '0 0 40px rgba(255, 87, 51, 0.8)',
              }}
            >
              {count}
            </motion.div>
          </motion.div>
        )}

        {phase === 'go' && (
          <motion.div
            key="go"
            initial={{ scale: 0, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            exit={{ scale: 1.5, opacity: 0 }}
            transition={{
              type: 'spring',
              stiffness: 150,
              damping: 10,
            }}
            className="relative z-10 text-center"
          >
            {/* Explosion effect */}
            {[...Array(12)].map((_, i) => (
              <motion.div
                key={i}
                className="absolute top-1/2 left-1/2 w-1 h-1 bg-forge-fire rounded-full"
                initial={{
                  x: 0,
                  y: 0,
                  scale: 1,
                  opacity: 1,
                }}
                animate={{
                  x: Math.cos((i * 30 * Math.PI) / 180) * 200,
                  y: Math.sin((i * 30 * Math.PI) / 180) * 200,
                  scale: 4,
                  opacity: 0,
                }}
                transition={{
                  duration: 0.8,
                  ease: 'easeOut',
                }}
              />
            ))}
            
            <motion.h1
              className="font-title text-8xl text-forge-fire tracking-wider relative"
              style={{
                textShadow: '0 0 60px rgba(255, 87, 51, 1)',
              }}
              animate={{
                scale: [1, 1.05],
              }}
              transition={{
                duration: 0.15,
                repeat: 4,
                repeatType: 'reverse',
              }}
            >
              LET'S GO!
            </motion.h1>
            
            <motion.div
              className="mt-4"
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.2 }}
            >
              <Icon
                name="flash_on"
                className="text-white text-6xl"
              />
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </motion.div>
  );
};