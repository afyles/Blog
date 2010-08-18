using MvcMusicStore.Models;

namespace Messages
{
    public class PlaceOrderCommand : ICommand
    {
        public ShoppingCart Cart { get; set; }
    }
}
