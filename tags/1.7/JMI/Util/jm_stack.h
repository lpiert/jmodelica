/*
    Copyright (C) 2012 Modelon AB

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, version 3 of the License.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef jm_stack_h_
#define jm_stack_h_

#include "jm_vector.h"

/* jm_stack is implemented on top of jm_vector right now. There is a couple of extra methonds that are convenient.
   TODO: Consider reimplementing on top of deque */
#define jm_stack(T) jm_mangle(jm_stack, T)

/*
// Stack handling functions.
// jm_stack_alloc allocates a stack with the given reserved memory
// Input:
//   capacity - initial stack capacity, can be 0
//   c - jm_callbacks callbacks, can be zero
// Returns:
//   Newly allocated stack
//extern jm_stack(T)* jm_stack_alloc(T)(size_t capacity,jm_callbacks*c );
*/
#define jm_stack_alloc(T) jm_mangle(jm_stack_alloc, T)

/* extern void jm_stack_free(T)(jm_stack(T)* a); */
#define jm_stack_free(T) jm_mangle(jm_stack_free, T)

/*
// jm_stack_init initializes a jm_stack allocated on stack.
// Input:
//   a - pointer to the stack to be initialized;
//   c - jm_callbacks callbacks, can be zero
//void jm_stack_init(T)(jm_stack(T)* a, jm_callbacks* c)
*/
#define jm_stack_init(T) jm_mangle(jm_stack_init, T)

/*
// jm_stack_free_data releases memory allocated for stack data
// This only needs to be called both for stack allocated jm_stack
//inline void jm_stack_free_data(T)(jm_stack(T)* a)
*/
#define jm_stack_free_data(T) jm_mangle(jm_stack_free_data, T)

/*
inline size_t jm_stack_get_size(T)(jm_stack(T)* a)
*/
#define jm_stack_get_size(T) jm_mangle(jm_stack_get_size, T)

/*
// jm_stack_reserve preallocates memory for the stack (to speed up consequent push)
// Returns: the actually reserved space. Can be smaller than "capacity" if memory allocation failed.
// Can be larger than "capacity" if more memory was previously allocated.
// size_t jm_stack_reserve(T)(jm_stack(T)* a, size_t capacity)
*/
#define jm_stack_reserve(T) jm_mangle(jm_stack_reserve, T)

/*
// jm_stack_push puts an element on the stack.
// Returns a pointer to the inserted element or zero pointer if failed.
// T* jm_stack_push_back(jm_stack(T)* a, T item)
*/
#define jm_stack_push(T) jm_mangle(jm_stack_push, T)

/*
  jm_stack_is_empty returns 1 if the stack is empty and 0 otherwize.
  int jm_stack_is_empty(jm_stack(T)*)
  */
#define jm_stack_is_empty(T) jm_mangle(jm_stack_is_empty, T)

/*
// jm_stack_pop gets the stack head and moves to the next element. Popping an empty stack gives assertion failure.
// T jm_stack_pop(jm_stack(T)* a)
*/
#define jm_stack_pop(T) jm_mangle(jm_stack_pop, T)

/*
// jm_stack_top gets the stack top. Call on an empty stack gives assertion failure.
// T jm_stack_top(jm_stack(T)* a)
*/
#define jm_stack_top(T) jm_mangle(jm_stack_top, T)

/*
// jm_stack_foreach calls f for each element in the stack. "data" parameter
// is forwarded to the function as the second argument.
// void jm_stack_foreach(T)(jm_stack(T)* a, void (*f)(T, void*), void * data)
*/
#define jm_stack_foreach(T) jm_mangle(jm_stack_foreach, T)


/* minimal number of items always allocated for the stack */
#define JM_STACK_MINIMAL_CAPACITY JM_VECTOR_MINIMAL_CAPACITY

/* maximum memory chunk (in items) to be allocated in push. */
#define JM_STACK_MAX_MEMORY_CHUNK JM_VECTOR_MAX_MEMORY_CHUNK

#define jm_stack_declare_template(T)		\
typedef jm_vector(T) jm_stack(T);					\
 \
static jm_stack(T)* jm_stack_alloc(T)(size_t capacity,jm_callbacks* c) { return jm_vector_alloc(T)(0, capacity, c); }	\
    \
static void jm_stack_free(T)(jm_stack(T) * a) { jm_vector_free(T)(a); } \
    \
static void jm_stack_init(T)(jm_stack(T)* a, jm_callbacks* c) { jm_vector_init(T)(a,0,c); }	\
\
static void jm_stack_free_data(T)(jm_stack(T)* a) { jm_vector_free_data(T)(a); } \
\
static size_t jm_stack_get_size(T)(jm_stack(T)* a) { return jm_vector_get_size(T)(a); } \
\
static size_t jm_stack_reserve(T)(jm_stack(T)* a, size_t capacity) { return jm_vector_reserve(T)(a, capacity);  } \
    \
static T* jm_stack_push(T)(jm_stack(T)* a, T item) { return jm_vector_push_back(T)(a, item); }\
    \
static int jm_stack_is_empty(T)(jm_stack(T)* a) { return ((jm_stack_get_size(T)(a) > 0)? 0:1); } \
    \
static T jm_stack_top(T)(jm_stack(T)* a) { \
    assert(!jm_stack_is_empty(T)(a)); \
    return jm_vector_get_item(T)(a,jm_vector_get_size(T)(a)-1) ; \
} \
            \
static T jm_stack_pop(T)(jm_stack(T)* a) { \
    T ret; \
    ret = jm_stack_top(T)(a); \
    jm_vector_resize(T)(a, jm_vector_get_size(T)(a) - 1); \
    return ret; \
} \
\
static void jm_stack_foreach(T)(jm_stack(T)* a, void (*f)(T, void*), void * data) { jm_vector_foreach_c(T)(a,f,data); }

jm_stack_declare_template(char)
jm_stack_declare_template(int)
jm_stack_declare_template(double)
jm_stack_declare_template(jm_voidp)
jm_stack_declare_template(size_t)
jm_stack_declare_template(jm_string)

#endif
