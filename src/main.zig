const std = @import("std");
const singly = @import("./singly.zig");

const assert = std.testing.expect;
const test_allocator = std.testing.allocator;
const expectSlice = std.testing.expectEqualSlices;

pub fn main() !void {
    var list = singly.Node([]const u8).init("Hello");
    list.append("World!");
    std.debug.print("{s}\n", .{list});
}


test "init singly" {
    var num = singly.Node(i32).init(5);
    assert(num.val == 5);

    var str = singly.Node([]const u8).init("Hello");
    expectSlice(u8, "Hello", str.val);
}

test "append" {
    var depth1 = singly.Node(?u8).init(null);
    depth1.append(6);
    assert(depth1.val == null);
    assert(depth1.next.?.val.? == 6);

    var depth2 = singly.Node(u8).init(1);
    depth2.append(2);
    depth2.append(3);
    assert(depth2.val == 1);
    assert(depth2.next.?.val == 2);
    assert(depth2.next.?.next.?.val == 3);
}
