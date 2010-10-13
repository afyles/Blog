namespace Schedule
{
    using System;
    using NServiceBus;

    /// <summary>
    /// Generic schedule that sends a tickle message to a given handler
    /// </summary>
    public interface ISchedule<T>
    {
        /// <summary>
        /// Determines how often the tickle message is sent
        /// </summary>
        /// <param name="interval"></param>
        /// <param name="messageConstructor"></param>
        void Every(TimeSpan interval, Func<T> messageConstructor);
    }
}
