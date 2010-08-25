using System;

namespace MvcMusicStore.Helpers
{
    public static class IdGenerator
    {
        public static Int32 Generate()
        {
            byte[] buffer = Guid.NewGuid().ToByteArray();
            return BitConverter.ToInt32(buffer, 0);
        }
    }
}