namespace ArchiveSubscriber
{
    using Messages;
    using NServiceBus;
    using System;
    using log4net;

    public class EventMessageHandler : IMessageHandler<IProductChangedEvent>
    {
        private static ILog log = LogManager.GetLogger("ArchiveSubscriber");

        public void Handle(IProductChangedEvent message)
        {
            log.Debug(String.Format("{0} Event Received for Product {0}: {1}", message.GetType().UnderlyingSystemType.Name, message.ProductNumber, message.Name));
        }
    }
}
