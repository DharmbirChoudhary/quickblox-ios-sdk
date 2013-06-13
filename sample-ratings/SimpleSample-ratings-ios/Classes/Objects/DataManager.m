//
//  DataManager.m
//  SimpleSample-ratings-ios
//
//  Created by Ruslan on 9/11/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import "DataManager.h"
#import "Movie.h"

@implementation DataManager

static DataManager *dataManager = nil;

+(DataManager *)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[self alloc] init];
    });
    
    return dataManager;
}

- (NSMutableArray *)movies {
    if (!_movies) {
        _movies = [[NSMutableArray alloc] init];
        
        Movie *movie = [[Movie alloc] init];
        [movie setMovieName:@"Ted"];
        [movie setMovieImage:@"ted.jpg"];
        [movie setGameModeID:202]; // taken from Admin panel (admin.quickblox.com, Ratings module, Game modes tab)
        [movie setMovieDetails:@"As the result of a childhood wish, John Bennett's teddy bear, Ted, came to life and has been by John's side ever since - a friendship that's tested when Lori, John's girlfriend of four years, wants more from their relationship."];
        [_movies addObject:movie];
        
        movie = [[Movie alloc] init];
        [movie setMovieName:@"Hachiko: A Dog's Tale"];
        [movie setMovieImage:@"hachiko.jpg"];
        [movie setGameModeID:203]; // taken from Admin panel (admin.quickblox.com, Ratings module, Game modes tab)
        [movie setMovieDetails:@"A drama based on the true story of a college professor's bond with the abandoned dog he takes into his home."];
        [_movies addObject:movie];
        
        movie = [[Movie alloc] init];
        [movie setMovieName:@"The Godfather"];
        [movie setMovieImage:@"godfather.jpg"];
        [movie setGameModeID:204]; // taken from Admin panel (admin.quickblox.com, Ratings module, Game modes tab)
        [movie setMovieDetails:@"The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son."];
        [_movies addObject:movie];
        
        movie = [[Movie alloc] init];
        [movie setMovieName:@"The Shawshank Redemption"];
        [movie setMovieImage:@"shawshank_redemption.jpg"];
        [movie setGameModeID:205]; // taken from Admin panel (admin.quickblox.com, Ratings module, Game modes tab)
        [movie setMovieDetails:@"Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency."];
        [_movies addObject:movie];
        
        movie = [[Movie alloc] init];
        [movie setMovieName:@"The Lord of the Rings: The Fellowship of the Ring"];
        [movie setMovieImage:@"the_lord_of_the_rings.jpg"];
        [movie setGameModeID:206]; // taken from Admin panel (admin.quickblox.com, Ratings module, Game modes tab)
        [movie setMovieDetails:@"An innocent hobbit of The Shire journeys with eight companions to the fires of Mount Doom to destroy the One Ring and the dark lord Sauron forever."];
        [_movies addObject:movie];
        
        movie = [[Movie alloc] init];
        [movie setMovieName:@"Fight Club"];
        [movie setMovieImage:@"fight_club.jpg"];
        [movie setGameModeID:207]; // taken from Admin panel (admin.quickblox.com, Ratings module, Game modes tab)
        [movie setMovieDetails:@"An insomniac office worker and a devil-may-care soap maker form an underground fight club that transforms into a violent revolution."];
        [_movies addObject:movie];
        
        movie = [[Movie alloc] init];
        [movie setMovieName:@"Harry Potter and the Deathly Hallows"];
        [movie setMovieImage:@"harry_potter.jpg"];
        [movie setGameModeID:208]; // taken from Admin panel (admin.quickblox.com, Ratings module, Game modes tab)
        [movie setMovieDetails:@"Harry, Ron and Hermione search for Voldemort's remaining Horcruxes in their effort to destroy the Dark Lord."];
        [_movies addObject:movie];
    }
    
    return _movies;
}

@end
