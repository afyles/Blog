using System;
using Messages;
using MvcMusicStore.Models;
using NServiceBus;

namespace StoreCommandHandler
{
    public class IPlaceOrderHandler : IHandleMessages<IPlaceOrderCommand>
    {
        public void Handle(IPlaceOrderCommand message)
        {
            MusicStoreEntities storeDB = new MusicStoreEntities();

            var order = new MvcMusicStore.Models.Order();

            order.Username = message.UserId;
            order.OrderDate = DateTime.Now;
            order.OrderId = message.OrderId;

            // Save Order
            storeDB.AddToOrders(order);
            storeDB.SaveChanges();

            //Process the order
            var cart = new ShoppingCart(message.CartId);

            cart.CreateOrder(order);
        }
    }
}
