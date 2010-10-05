using System.Linq;
using Messages;
using MvcMusicStore.Models;
using NServiceBus;

namespace BillingSubscriber
{
    public class BillingHandler : IHandleMessages<IOrderAcceptedEvent>
    {
        public IBus Bus { get; set; }

        public void Handle(IOrderAcceptedEvent message)
        {
            MusicStoreEntities storeDB = new MusicStoreEntities();

            var order = storeDB.Orders.Single(o => o.OrderId == message.OrderId);

            var paymentInstrument = storeDB.PaymentInstruments.Single(pi => pi.UserName == order.Username);

            var authorizedEvent = this.Bus.CreateInstance<IAuthorizePaymentEvent>(p => p.OrderId = order.OrderId);

            // authorize the card...
            if (order.Total < 100)
                authorizedEvent.Authorized = true;
            else
                authorizedEvent.Authorized = false;

            this.Bus.Send(authorizedEvent);

        }
    }
}
