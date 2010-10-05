using Messages;
using NServiceBus;
using NServiceBus.Saga;
using System;

namespace ShippingSubscriber
{
    public class ShippingSaga : Saga<ShippingSagaData>,
        IAmStartedByMessages<IOrderAcceptedEvent>,
        IHandleMessages<IAuthorizePaymentEvent>,
        IHandleMessages<IOrderPickedEvent>
    {
        public override void ConfigureHowToFindSaga()
        {
            base.ConfigureMapping<IOrderAcceptedEvent>(s => s.OrderId, e => e.OrderId);
            base.ConfigureMapping<IAuthorizePaymentEvent>(s => s.OrderId, e => e.OrderId);
            base.ConfigureMapping<IOrderPickedEvent>(s => s.OrderId, e => e.OrderId);
        }

        public void Handle(IOrderAcceptedEvent message)
        {
            base.Data.PaymentAuthorized = true;
            base.Data.OrderId = message.OrderId;
            Console.WriteLine("Setting Saga Order Data to {0}", base.Data.OrderId);

            base.Bus.SendLocal<IPickOrderCommand>( p => p.OrderId = message.OrderId);
        }

        public void Handle(IAuthorizePaymentEvent message)
        {
            base.Data.PaymentAuthorized = message.Authorized;
            this.TryComplete();
        }

        public void Handle(IOrderPickedEvent message)
        {
            base.Data.OrderPicked = true;
            Console.WriteLine("Setting Saga Order Picked to {0}", base.Data.OrderPicked);

            this.TryComplete();
        }

        private void TryComplete()
        {
            if (base.Data.OrderPicked && Data.PaymentAuthorized)
                MarkAsComplete();
        }

        public override void Timeout(object state)
        {
            MarkAsComplete();
        }
    }
}
