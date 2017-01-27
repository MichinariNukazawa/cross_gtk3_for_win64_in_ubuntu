#include <gtk/gtk.h>

int main (int argc, char *argv[])
{
	gtk_init(&argc, &argv);

	GtkWidget *window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
	gtk_widget_set_size_request (window, 200, 100);
	gtk_window_set_title(GTK_WINDOW(window), "Test app");

	GtkWidget *box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 5);
	GtkWidget *label = gtk_label_new("hello");
	GtkWidget *button = gtk_button_new_with_label ("button");

	gtk_box_pack_start(GTK_BOX (box), label, TRUE, TRUE, 0);
	gtk_box_pack_start(GTK_BOX (box), button, FALSE, FALSE, 0);
	gtk_container_add(GTK_CONTAINER (window), box);

	gtk_widget_show_all(window);
	gtk_main();

	return 0;
}

