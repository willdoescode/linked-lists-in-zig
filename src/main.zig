const std = @import("std");
const print = std.debug.print;

const Node = struct {
    const Self = @This();

    val: i32,
    next: ?*Node,
    allocator: *std.mem.Allocator,

    fn init(val: i32, allocator: *std.mem.Allocator) Self {
        return Self{ .val = val, .next = null, .allocator = allocator };
    }

    fn append(self: *Self, val: i32) anyerror!void {
        if (self.next) |next_node| {
            try next_node.append(val);
        } else {
            var node = try self.allocator.create(Node);
            node.* = Node.init(val, self.allocator);

            self.next = node;
        }
    }

    pub fn format(self: *const Self, comptime fmt: []const u8, options: std.fmt.FormatOptions, writer: anytype) !void {
        var cur = self;
        try writer.print("{} ", .{self.val});
        while (cur.next) |next| : (cur = next) {
            try writer.print("-> {} ", .{next.val});
        }
    }

    fn deinit(self: *Self) void {
        self.allocator.destroy(self);
    }
};

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = &arena.allocator;

    var list = Node.init(5, allocator);
    defer list.deinit();

    try list.append(6);
    try list.append(7);

    print("{}\n", .{list});
}

