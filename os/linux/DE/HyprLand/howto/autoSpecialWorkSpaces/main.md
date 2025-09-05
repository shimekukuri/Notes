# Hyprland How To - Autostart programs into multiple special workspaces

## Abstract
An easy to understand guide on to create special workspaces in Hyprland (DE) on your favorite linux distro
Press enter or click to view image in full size
Photo by Xavier Cee on Unsplash

About six months ago I switched over from my trusted i3wm DE on my archcraft-linux install over to hyprland. At first,
I was a bit ticked off as hyprland at the time didn’t have a great way of handling global in-app shortcuts (not
shortcuts in how we set them in the config files) but the increased security that wayland offers over X11 is
undeniable. Wayland is the future of linux and so i could either rage against the machine or lean into it and learn
how to use it.

Six months later, I couldn’t be happier. Not only have I fallen in love with Hyprland but it truly has become my
“default.” I3wm will still, however, always hold a special place in my heart.

If you’re familiar with tiling window managers then I don’t have to tell you how great they are and how they can
decrease your use of a mouse and enhance your productivity all in one fell swoop. But if you’re unfamiliar with them,
it may be best to learn a bit more so that you can see how beneficial they can be to your workflow.

But I digress, you came to learn how to create an UNLIMITED number of special workspaces in hyprland, so here we go.
What’s a Special Workspace?

In i3wm we were able to utilize a workspace called a “Stratchpad” and the main benefit of placing a program in a
special workspace is that you’re able to call it forward at any time, without it switching off your current workspace
and it’s always running in the background, regardless of whether you switch to a different workspace and can be easily
called forward at any time.

I wrote a quick guide a few months ago on this, but this one is much more up to date as I’ve figured out the necessary
components to make it truly seamless with minimal inferences.

If the Hyprland team ever comes across this guide I hope that they can include it in their documentation, as the
documentation didn’t really go in depth into how to really set everything up and I know it can be quite useful to
people that would like to.
Creating a Special Workspace

In order to set up special workspaces in Hyprland we’re going to tackle these key config alterations:

The first thing that you want to do is:

    Open up your Hyprland config file

Mine is located in .config/hypr/

but yours may be located somewhere else depending on your distribution.

2. You want create a special workspace by defining your keybinds for this space

For example, take a look at some of the workspaces that I’ve created:

# Special Workspaces
bind = ALT, X, togglespecialworkspace, ferdium
bind = ALT, E, togglespecialworkspace, mail
bind = ALT, B, togglespecialworkspace, logseq
bind = ALT, T, togglespecialworkspace, todoist
bind = ALT, P, togglespecialworkspace, allusion
bind = ALT, V, togglespecialworkspace, youtube

We’re doing a few things in this simple config.

Binding the special work space to a key combination (in my case, ALT + Letter)
Naming the special workspace (the program names that you see are the names I’ve given each workspace, you can name
them whatever you want. Since I only use one program per workspace, I’ve labeled them the same name of the program’s
within it)

Now, do this for all of the special work spaces that you want to create with whatever key combinations that you’d like
to use for them and save. As far as I know, there are no limitations to the number of special workspaces that you can
create.

Once you save, press your key combos, you’ll notice that your screen dims and it opens up to nothing, this is great,
it mean’s that the special workspace is working, now we want to put something in there.

So to recap the formula is:

bind command → Key Binds → Togglespecialworkspace command → Workspace name

For the purposes of this guide, I won’t be using “SEND TO SPECIAL WORKSPACE” config as I personally do not use this
and opt to have my specific applications auto start in those workspaces instead.
Get Ed’s stories in your inbox

Join Medium for free to get updates from this writer.

SEND TO SPECIALWORKSPACE can be configured easily following the same structure as the other SENDTOWORKSPACE features
or you can HOLD MOD and DRAG IT TO AN OPEN SPECIAL WORKSPACE, but if anyone has any questions feel free to ask me in
the comments.
Autostart Apps & Bind Apps on Special Workspaces

Now that your special workspaces are all set up, we want edit our config file to :

    Autostart Applications
    Bind Applications to Certain Workspaces with Custom Window Rules

So let’s tackle the first of these two:
Autostarting Apps on Special

I’m going to show you how I’ve configred my apps to startup in my hyprland config file, that pertain to the special
workspaces that I’ve listed above.

Here’s my config:

# Autostart Special Workspace Apps
exec-once = [workspace special:ferdium silent] ferdium
exec-once = [workspace special:logseq silent] logseq
exec-once = [workspace special:mail silent] betterbird
exec-once = [workspace special:todoist silent] com.todoist.Todoist
exec-once = [workspace special:allusion silent] allusion
exec-once = [workspace special:youtube silent] youtube-music

Explanation:

We’re doing a few things here.

Using the parameter exec-once to execute the program once per session

defining which workspace we want to target with our application, for example [workspace special:ferdium silent] is
targeting the special workspace that I’ve named ferdium and silent is just saying that we want it to open up discretely.

picking an app to launch by putting in it’s command-line executable name, for the case of ferdium it’s executable name
is ferdium for the case of todoist, the app’s internal executable name is com.todoist.Todoist

So to recap it’s:
Exec command → Workspace Name → App Name

Now your applications will auto start on these special workspaces whenever you turn on your computer. If you want to
test it, give the ol’ command line a good reboot now to see the fruits of your labor.

However, this will only autostart these applications in these workspaces, it will not bind them to “live” in these
workspaces, for that you will need to configure your…
Custom Window Rules to Bind Apps to Your Special Workspaces

When you do this, ever time you open the app it will go to it’s new home in the special workspace that you set for it.

This rule is not specific to just special workspaces, and can be used to bind any program to any workspace in
Hyprland, so you may already be familar with it.

Example config:

# Special Workspace Startup Apps
windowrule = workspace special:ferdium, ^(Ferdium)$
windowrule = workspace special:mail, ^(betterbird)$
windowrule = workspace special:logseq, ^(Logseq)$
windowrule = workspace special:youtube, ^(youtube-music)$
windowrule = workspace special:allusion, ^(allusion)$
windowrule = workspace special:todoist, ^(com.todoist.Todoist)$

This config edit binds (for example) the app todoist whose app name is com.todoist.Todoist to the special workspace
i’ve created for it called todoist. This ensures that whenever the app is launched it automatically opens in the
workspace that I’ve definied for it, regardless if it was on auto start or not.

This helps because if you close an autostarted app, it will no longer start up in the special workspace unless a
special window rule like this is definined.

So to recap this formula:

    windowrule → special workspace name → ^(applicationame)$

The carrot and dollar sign are part of the formula necessary for this hyprland rule so don’t forget to include them.
As for application names, if you are ever in doubt, you can run xprop from the command line and then click on the
program and take notice of it’s WM_CLASS(String) which will most likely give you two names, one of those should work.
Conclusion

There you have it! If you’d made it this far then you have successfully

    Created Special Workspaces
    Created autostart configs for your special workspace apps
    Binded Your Special Workspace apps to specific special workspaces

I hope that this helps and that you, like I, keep using hyprland and discovering everything that it can do for your productivity.

Thanks for reading and I truly hoped that this helped you on How to Create Multiple Special Workspaces for Hyprland on Linux.

## Directory

## Useful Links
[Where I go this from](https://medium.com/@mynameised/how-to-create-multiple-special-workspaces-in-hyprland-b4de8bc2ddd7)

## Tags
[[hyprland-how-to]]
