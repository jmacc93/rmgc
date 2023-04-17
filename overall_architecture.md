

Because of:
  * The limitation that each node can have only one script attached, and
  * The problems inherent to inheritance in object oriented programming
I made use of what I call *composite* objects for this game

A composite object in this context is a node without a script attached, which has child nodes that provide all their functionality through their scripts. So, its like, instead of having its own script, it has a bunch of scripts in child nodes. Typically, these child nodes are just plain old `Node` nodes with one script attached and no children of their own. I'll refer to nodes without script that have their functionality provided by children with scripts as 'composite nodes' or just 'composites'

I preferred to:
  * Keep functionality-providing child nodes only one level deep, ie: only immediate children of the composite node. Though, functionality-providing children may be composite nodes themselves, and have children which provide their functionality, or augment their functionality
  * Prevent as much functionality-providing child node interaction as possible, to keep complexity as low as possible
  * Make composite nodes' behaviors as granular as possible; meaning: I tried to split their behavior up as much as possible, and have as many functionality-providing child nodes as possible.

---

Some problems inherent to this approach in Godot are that:
  * Objects cannot new class properties or methods defined at runtime
  * Objects' user signals cannot be deleted once they are defined
  * There is no built-in infrastructure for signaling when properties / methods are created, modified, etc

To solve these problems:
  * I make heavy use of Object metadata for runtime property and method changes
  * Use functions in the libraries `Watch` and `Comp` for getting and setting properties, calling methods, and for signaling

`Comp` functions like `Comp.set_prop` and `Comp.get_prop` also don't make a distinction between regular class properties and metadata properties, so they can be used to replace `obj.set(prop, value)`, `obj.get(prop)`, `obj.set_meta(prop, value)`, `obj.get_meta(prop, value)`. Similarly for methods, `Comp.run_method` and `Comp.call_method` don't make a distinction. This allows you to essentially treat regular nodes and composite nodes the same

---

Another note: I generally preferred closures when a node has to be essentially shared between two different parent nodes. For example: gear ui cells are ui elements that appear in one location on the ui but they are basically owned by the gear node that is responsible for making them. So, when gear nodes are asked to create their ui cells through calls to their `make_ui_cell` methods, they internally create closures for the ui cells' methods like `handle_left_clicked`. So, calling methods like `handle_left_clicked` are really calling back to the gear node that created them

See `makeGearUiCell` (which is a functionality-providing node for use as the child of a composite node) for the prototypical implementation of this behavior

---

The game itself actually takes place in the `gameUniverse.tscn` scene, which is the main scene for the project, and which has a set of child viewport nodes, and one active viewport node inside of a `SubViewportContainer` node. The currently visible viewport is in the `SubViewportContainer` node, the other viewports are running worlds in the background which aren't visible

The viewport in the `SubViewportContainer` and another viewport are switched when the player moves between worlds. When the player goes into a world that isn't previously loaded, the world's scene (whose file is referenced in the portal the player went through) is instanced and placed as the child of a new viewport, which is added to the `gameUniverse` node, and then that node is switched with the currently visible node in the `SubViewportContainer`

Each viewport should have one game 'world' node in the group `game_world`










