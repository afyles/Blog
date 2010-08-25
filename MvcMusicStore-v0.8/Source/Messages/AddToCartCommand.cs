using MvcMusicStore.Models;

namespace Messages
{
    public interface IAddToCartCommand : ICommand
    {
        string CartId { get; set; }
        int AlbumId { get; set; }
    }
}
