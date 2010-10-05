using System.Linq;
using Messages;
using MvcMusicStore.Models;
using NServiceBus;

namespace ShippingSubscriber
{
    public class PickOrderHandler : IHandleMessages<IPickOrderCommand>
    {
        public IBus Bus { get; set; }

        #region IMessageHandler<IOrderAcceptedEvent> Members

        public void Handle(IPickOrderCommand message)
        {
            MusicStoreEntities storeDB = new MusicStoreEntities();

            var order = storeDB.Orders.Single(o => o.OrderId == message.OrderId);

            var shipNote = new ShippingNote
            {
                FirstName = order.FirstName,
                LastName = order.LastName,
                Address = order.Address,
                City = order.City,
                State = order.State,
                PostalCode = order.PostalCode
            };

            foreach (var detail in order.OrderDetails)
            {
                var inventoryPosition = storeDB.InventoryPositions.Single(p => p.Album.AlbumId == detail.AlbumId);

                if (inventoryPosition.BalanceOnHand >= detail.Quantity)
                {
                    inventoryPosition.BalanceOnHand -= detail.Quantity;
                    shipNote.ShippedQuantity += detail.Quantity;
                }
                else
                {
                    shipNote.BackOrderQuantity = detail.Quantity - shipNote.ShippedQuantity;
                }
            }

            storeDB.AddToShippingNotes(shipNote);

            storeDB.SaveChanges();

            this.Bus.SendLocal<IOrderPickedEvent>(
                o =>
                {
                    o.ShippingNoteId = shipNote.ShippingNoteId;
                    o.OrderId = order.OrderId;
                });

        }

        #endregion
    }
}
