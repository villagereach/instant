package main

// func setup() {

// 	fmt.Println("getting ready")

// 	home, _ := os.UserHomeDir()
// 	dotfiles := filepath.Join(home, ".instant")
// 	fmt.Println("...checking for config folder")

// 	// check for dotfolder, create if it doesn't exist
// 	if _, err := os.Stat(dotfiles); os.IsNotExist(err) {
// 		fmt.Println("config folder does not exist, creating it")
// 		os.Mkdir(dotfiles, 0700)
// 		fmt.Println("created")
// 	} else {
// 		fmt.Println("config folder exists")
// 	}

// 	// check repo and clone or pull
// 	fmt.Println("...cloning or pulling latest code from repo")

// 	repo := filepath.Join(dotfiles, "instant")
// 	if _, err := os.Stat(repo); os.IsNotExist(err) {
// 		fmt.Println("...repo folder does not exist, cloning it")
// 		_, err := git.PlainClone(repo, false, &git.CloneOptions{
// 			URL:      "https://github.com/openhie/instant",
// 			Progress: os.Stdout,
// 		})
// 		if err != nil {
// 			fmt.Println("error")
// 		}
// 		fmt.Println("successfully cloned")
// 	} else {
// 		fmt.Println("...repo folder exists, pulling changes")
// 		const (
// 			repoURL = "https://github.com/openhie/instant.git"
// 		)

// 		dir, _ := ioutil.TempDir("", "temp_dir")

// 		options := &git.CloneOptions{
// 			URL: repoURL,
// 		}

// 		_, err := git.PlainClone(dir, false, options)
// 		if err != nil {
// 			fmt.Println("error")
// 		}
// 	}
// 	fmt.Println("git repo is ready")
// }
