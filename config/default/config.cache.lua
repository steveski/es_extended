Config.Modules.Cache = {
  -- in minutes, the amount of time between cache updates to the database
  ServerSaveInterval           = 10,
  EnableDebugging              = true,
  BasicCachedTables            = {
    "vehicles",
    "usedPlates"
  },
  IdentityCachedTables         = {
    "owned_vehicles",
    "identities"
  },
  BasicCachedTablesToUpdate    = {
  }
}
