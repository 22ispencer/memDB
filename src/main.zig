const std = @import("std");
const net = std.net;
const mem = std.mem;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    // You can use print statements as follows for debugging, they'll be visible when running tests.
    try stdout.print("Logs from your program will appear here!", .{});

    // Uncomment this block to pass the first stage

    const address = try net.Address.resolveIp("127.0.0.1", 6379);

    var listener = try address.listen(.{
        .reuse_address = true,
    });
    defer listener.deinit();

    var buf: [128]u8 = undefined;
    while (true) {
        const connection = try listener.accept();
        defer connection.stream.close();

        try stdout.print("accepted new connection", .{});

        while (true) {
            const read = try connection.stream.read(&buf);

            if (read == 0) {
                continue;
            }

            try connection.stream.writeAll("+PONG\r\n");
        }
    }
}
