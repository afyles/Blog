namespace Subscriber3
{
    using NServiceBus;
    using System;
    using log4net;

    public class EventMessageHandler : IMessageHandler<Messages.New.IProductUpdatedEvent>
    {
        private static ILog log = LogManager.GetLogger("ArchiveSubscriber");

        public void Handle(Messages.New.IProductUpdatedEvent message)
        {
            log.Debug(String.Format("{0} Event Received for Product {1}: {2} : {3}", message.GetType().UnderlyingSystemType.Name, message.ProductNumber, message.Name, message.DepartmentNumber));
        }
    }
}
