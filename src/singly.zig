const std = @import("std");
const print = std.debug.print;

pub fn Node(comptime T: type) type {
    return struct {
        const Self = @This();

        val: T,
        next: ?*Self,

        pub fn init(val: T) Self {
            return Self{ .val = val, .next = null };
        }

        pub fn append(self: *Self, val: T) void {
            if (self.*.next) |node| {
                node.append(val);
            } else {
                self.*.next = &Node(T).init(val);
            }
        }
    };
}

// pub fn format(self: Self, comptime fmt: []const u8, options: std.fmt.FormatOptions, writer: anytype) !void {
// var hold = self;
// try writer.print("{d} ->", .{self.val});
// while (hold.next) |n| {
//   hold = n.*;
//   try writer.print("{d}->", .{hold.val});
// }
// }
