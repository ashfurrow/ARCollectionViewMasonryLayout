ARCollectionViewMasonryLayout
=============================

[![Build Status](https://travis-ci.org/AshFurrow/ARCollectionViewMasonryLayout.svg)](https://travis-ci.org/AshFurrow/ARCollectionViewMasonryLayout)

ARCollectionViewMasonryLayout is a `UICollectionViewLayout` subclass for creating flow-like layouts with dynamic widths or heights.

![Screenshot](Screenshots/ARCollectionViewMasonryLayout.png)

Usage
----------------

Create a collection view with an instance of the `ARCollectionViewMasonryLayout`. The collection view's delegate *must* conform to the `ARCollectionViewMasonryLayoutDelegate` protocol in order to retrieve the variable dimensions of the cells.

Demo Project
----------------

This repository contains a demo project showing the use of the collection view layout. The view controller creates a number of `ARModel` instances which represent a colour and dimension of a cell. These values are randomized in `viewDidLoad`.

When the collection view asks for a cell, the cell's background colour is set to the corresponding model's colour. The layout queries the collection view's delegate for dimension information, and the corresponding model's dimension is returned.

License
----------------

Licensed under MIT.

Credits
----------------

Originally created by [Orta](https://github.com/orta) for [Artsy](https://artsy.net).
