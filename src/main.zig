const std = @import("std");
const print = std.debug.print;

const Node = struct {
    const Self = @This();

    val: i32,
    next: ?*Node,

    fn init(val: i32) Self {
        return Self { .val = val, .next = null };
    }

    fn deinit(self: *Self, previous: ?*Self, allocator: *std.mem.Allocator) void {
        if (previous) |p| allocator.destroy(p);
        if (self.next) |next| next.deinit(self, allocator)
        else allocator.destroy(self);
    }

    fn append(self: *Self, val: i32, allocator: *std.mem.Allocator) anyerror!void {
        if (self.next) |next| try next.append(val, allocator)
        else {
            var node = try allocator.create(Node);
            node.* = Node.init(val);
            self.next = node;
        }
    }

    fn at(self: *Self, index: usize) ?Self {
        if (index == 0) return self.*
        else if (self.next) |next| return next.at(index - 1)
        else return null;
    }

    pub fn format(self: *const Self, comptime fmt: []const u8, options: std.fmt.FormatOptions, writer: anytype) !void {
        var cur = self;
        try writer.print("{}", .{cur.val});
        while (cur.next) |next| : (cur = next) {
            try writer.print(" -> {}", .{next.val});
        }
    }
};

// Manage allocator
const List = struct {
    const Self = @This();

    head: *Node,
    len: usize,
    allocator: *std.mem.Allocator,

    fn init(val: i32, allocator: *std.mem.Allocator) Self {
        var node = allocator.create(Node) catch |_| @panic("Could not create Node");
        node.* = Node.init(val);
        return Self { .head = node, .len = 1, .allocator = allocator };
    }

    fn deinit(self: *Self) void { self.head.deinit(null, self.allocator); }

    fn append(self: *Self, val: i32) void { 
        self.head.append(val, self.allocator) 
        catch |_| @panic("Could not append"); 
        self.len += 1;
    }

    fn at(self: *Self, index: usize) ?Node {
        return self.head.at(index);
    }

    pub fn format(self: *const Self, comptime fmt: []const u8, options: std.fmt.FormatOptions, writer: anytype) !void {
        var cur = self.head;
        try writer.print("{}", .{cur.val});
        while (cur.next) |next| : (cur = next) {
            try writer.print(" -> {}", .{next.val});
        }
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(!gpa.deinit());
    const allocator = &gpa.allocator;

    var list = List.init(1, allocator);
    defer list.deinit();
    {var i: usize = 2; while (i <= 10) : (i += 1) { list.append(@intCast(i32, i)); }}

    print("{}\n", .{list});
    print("{}\n", .{list.len});
    print("{}\n", .{list.at(5)});
}
