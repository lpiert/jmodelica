package org.jmodelica.util;

import java.util.Iterator;
import java.util.NoSuchElementException;

public class ChainedIterator<E> implements Iterator<E> {
	
	private Iterator<? extends E>[] its;
	private int i;
	
	public ChainedIterator(Iterator<? extends E>[] its) {
		this.its = its;
	}
	
	public ChainedIterator(Iterator<? extends E> it1, Iterator<? extends E> it2) {
		this(new Iterator[] { it1, it2 });
	}

	public boolean hasNext() {
		while (i < its.length && !its[i].hasNext())
			i++;
		return i < its.length;
	}

	public E next() {
		if (!hasNext())
			throw new NoSuchElementException();
		return its[i].next();
	}

	public void remove() {
		throw new UnsupportedOperationException();
	}

}
