using Messages;
using System;

namespace MvcMusicStore.Helpers
{
    public static class ServiceAgent<T> where T : ICommand
    {
        public static void Send(Action<T> messageConstructor)
        {
            if (null != messageConstructor)
                MvcApplication.Bus.Send<T>(messageConstructor);
        }
    }
}