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

    fn fromList(list: []const i32, allocator: *std.mem.Allocator) anyerror!Self {
        var ret = Self{ .val = list[0], .allocator = allocator, .next = null };

        for (list[1..]) |item| {
            try ret.append(item);
        }

        return ret;
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
        try writer.print("{}", .{self.val});
        while (cur.next) |next| : (cur = next) {
            try writer.print(" -> {}", .{next.val});
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

    var list = try Node.fromList(&[_]i32{ 1, 2, 3, 4 }, allocator);
    defer list.deinit();

    try list.append(5);

    print("{}\n", .{list});
}
