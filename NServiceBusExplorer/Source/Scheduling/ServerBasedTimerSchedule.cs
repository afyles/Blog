namespace Schedule
{
    using System;
    using NServiceBus;
    using System.Timers;
    using System.Collections.Generic;

    /// <summary>
    /// Basic schedule that uses System.Timers.Timer
    /// </summary>
    /// <typeparam name="T">The type of tickle message</typeparam>
    public class ServerBasedTimerSchedule<T> : IDisposable, ISchedule<T> where T : IMessage
    {
        private readonly IBus bus;
        private readonly List<Timer> timers = new List<Timer>(0);

        public ServerBasedTimerSchedule(IBus bus)
        {
            this.bus = bus;
        }

        /// <summary>
        /// Starts a Timer and sends a message locally for every elapsed event
        /// </summary>
        /// <param name="interval"></param>
        /// <param name="messageConstructor"></param>
        public void Every(TimeSpan interval, Func<T> messageConstructor)
        {

            Timer timer = new Timer(interval.TotalMilliseconds);
            timer.Elapsed +=
                (o, e) =>
                {
                    this.bus.SendLocal(messageConstructor());
                };

            timer.Start();
            this.timers.Add(timer);
        }

        /// <summary>
        /// Kills the Timers
        /// </summary>
        public void Dispose()
        {
            this.Dispose(true);
            GC.SuppressFinalize(this);
        }

        /// <summary>
        /// Kills the Timer resources
        /// </summary>
        /// <param name="disposing"></param>
        protected virtual void Dispose(Boolean disposing)
        {
            if (disposing)
            {
                if (null != this.timers)
                    this.timers.ForEach(t => t.Dispose());
            }
        }
    }
}
