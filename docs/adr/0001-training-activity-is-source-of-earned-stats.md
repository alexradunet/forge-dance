# Training Activity is the source of earned stats

Lesson and Workout completion records preserve their awarded XP and local completion date; Profile XP and Streak are repairable projections of those records. Completion remains successful when projection persistence fails because making Profile the source of truth would couple training durability to a denormalized write and catalog changes would retroactively alter earned XP.
