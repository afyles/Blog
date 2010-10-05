namespace ShippingSubscriber
{
    using System;
    using NServiceBus.Saga;

    public class ShippingSagaData : IContainSagaData
    {
        public virtual System.Guid Id{ get; set; }
        public virtual String OriginalMessageId { get; set; }
        public virtual String Originator { get; set; }
        public virtual Boolean PaymentAuthorized { get; set; }
        public virtual Int32 OrderId { get; set; }
        public virtual Boolean OrderPicked { get; set; }
    }
}
