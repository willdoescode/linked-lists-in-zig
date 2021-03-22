const std = @import("std");
const print = std.debug.print;

const Node = struct {
  const Self = @This();

  val: i32,
  next: ?*Node,

  pub fn init(val: i32) Node {
    return Node {
      .val = val,
      .next = null
    };
  }

  pub fn append_front(self: *Self, val: i32) void {
    var next = Node.init(val);
    var hold: ?*Node = null;
    if (self.next) |n| {
      hold = n;
    }
    self.next = &next;
    if (hold) |n| {
      self.next.?.*.next = n;
    }
  }
};

pub fn main() !void {
  var node = Node.init(5);
  node.append_front(3);
  node.append_front(4);
  print("{}\n", .{node});
}
