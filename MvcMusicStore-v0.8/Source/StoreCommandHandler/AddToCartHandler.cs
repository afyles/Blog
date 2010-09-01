using System.Linq;
using Messages;
using MvcMusicStore.Models;
using NServiceBus;

namespace StoreCommandHandler
{
    public class AddToCartHandler : IHandleMessages<IAddToCartCommand>
    {
        public void Handle(IAddToCartCommand message)
        {
            MusicStoreEntities storeDB = new MusicStoreEntities();

            // Retrieve the album from the database
            var addedAlbum = storeDB.Albums
                .Single(album => album.AlbumId == message.AlbumId);

            // Add it to the shopping cart
            var cart = new ShoppingCart( message.CartId );

            cart.AddToCart(addedAlbum);
        }
    }
}
