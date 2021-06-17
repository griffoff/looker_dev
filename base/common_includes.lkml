include: "//core/root.lkml"
include: "/views/explore_level_parameters.view"

# add project specific common joins to the root explore
# so that all view explores will have this functionality
explore: +root {
  join: explore_level_parameters {}
}
