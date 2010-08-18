using MvcMusicStore.Models;

namespace Messages
{
    public interface IAddToCartCommand : ICommand
    {
        Cart Item { get; set; }
    }
}
