

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

A note about connections between functionality-providing children and composite nodes:

In these child nodes' scripts, I use `_notification` with the `NOTIFICATION_PARENTED` and `NOTIFICATION_UNPARENTED` enums to check for when to add the child's functionality to its immediate compose node parent. For an example of this, look at the file `res://characters/scripts/healthStats.tscn`

However, this doesn't work when the composite isn't the immediate parent of a functionality-providing child node. In the case a f-p child node is a deep child of a composite node, I instead use the `tree_entered` and `tree_exited` signals, and in each I get the composite parent again to check the node tree topology between them is persevered. If the connection between the child and composite parent are maintained then I don't do anything, if its broken then I do the respective functionality adding / removing

Why do this, instead of just getting parented / unparented notifications? Because parenting / unparenting notifications are only emitted when the child node is added as a child to a node, so if the child's parent isn't the target composite, but instead some other node, and that node is removed (taking the child node with it) then the child node's `NOTIFICATION_UNPARENTED` won't be emitted. So we have to use tree exit signals, but we can't use `_exit_tree` because its "Called when the node is *about* to leave the SceneTree", and so we can't test whether it was the parent composite that was removed from the tree (and thus the child shouldn't remove its functionality from the parent composite), or if it was a node between the child and composite parent that was removed. So, instead we use the `tree_exited` signal, and for consistency we use the `tree_entered` signal too (instead of `_enter_tree`). Check out `res://gear/armors/armorGearBehavior.tscn` for an example of this

Note that a functionality-providing child may be a n-deep child of a composite like this because it is a child of a functionality-providing scene node that is the child of the composite parent. See `res://ui/playerUi.tscn` for an example of this


---

Another note: I generally preferred closures when a node has to be essentially shared between two different parent nodes. For example: gear ui cells are ui elements that appear in one location on the ui but they are basically owned by the gear node that is responsible for making them. So, when gear nodes are asked to create their ui cells through calls to their `make_ui_cell` methods, they internally create closures for the ui cells' methods like `handle_left_clicked`. So, calling methods like `handle_left_clicked` are really calling back to the gear node that created them

See `makeGearUiCell` (which is a functionality-providing node for use as the child of a composite node) for the prototypical implementation of this behavior

---

The game itself actually takes place in the `gameUniverse.tscn` scene, which is the main scene for the project, and which has a set of child viewport nodes, and one active viewport node inside of a `SubViewportContainer` node. The currently visible viewport is in the `SubViewportContainer` node, the other viewports are running worlds in the background which aren't visible

The viewport in the `SubViewportContainer` and another viewport are switched when the player moves between worlds. When the player goes into a world that isn't previously loaded, the world's scene (whose file is referenced in the portal the player went through) is instanced and placed as the child of a new viewport, which is added to the `gameUniverse` node, and then that node is switched with the currently visible node in the `SubViewportContainer`

Each viewport should have one game 'world' node in the group `game_world`

---








