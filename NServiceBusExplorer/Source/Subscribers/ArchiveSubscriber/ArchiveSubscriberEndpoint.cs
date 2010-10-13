namespace ArchiveSubscriber
{
    using NServiceBus;
    using NServiceBus.Host;
    using Messages;

    class ArchiveSubscriberEndpoint : IWantToRunAtStartup
    {
        public IBus Bus { get; set; }

        #region IWantToRunAtStartup Members

        public void Run()
        {
            this.Bus.Subscribe<IProductUpdatedEvent>();
            this.Bus.Subscribe<IProductCreatedEvent>();
        }

        public void Stop()
        {
            this.Bus.Unsubscribe<IProductUpdatedEvent>();
            this.Bus.Unsubscribe<IProductCreatedEvent>();
        }

        #endregion
    }
}
